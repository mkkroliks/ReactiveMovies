//
//  PopularMoviesSectionViewModel.swift
//  ReactiveMovies
//
//  Created by Maciej Krolikowski on 12/10/2020.
//  Copyright © 2020 Maciej Krolikowski. All rights reserved.
//

import SwiftUI
import Combine

final class PopularMoviesSectionViewModel: ObservableObject {
    
    @Published var movies: [MovieDTO] = []
    
    @ObservedObject var typedText: TypedText = TypedText()
    
    private var fetchedData: [MovieDTO] = []
    
    private var subscriptions = Set<AnyCancellable>()
    
    private var currentPage = 1
    
    var isSearching: Bool {
        return typedText.value.count > 0
    }
    
    init() {
        fetchMovies(page: 1)
        
        typedText.$value
            .map { typedString -> [MovieDTO] in
                if typedString.count > 0 {
                    let movies = self.fetchedData.filter { $0.title.contains(typedString) }
                    return movies
                } else {
                    return self.fetchedData
                }
            }
            .assign(to: \.movies, on: self)
            .store(in: &subscriptions)
    }
    
    func fetchNextPage() {
        fetchMovies(page: currentPage + 1)
    }
    
    private func fetchMovies(page: Int) {
        MoviesDBService.shared
            .getPopular(page: page)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: { response in
                self.movies += response.results
                self.fetchedData += response.results
                self.currentPage = response.page ?? 0
            })
        .store(in: &subscriptions)
    }
}
