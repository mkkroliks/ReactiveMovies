//
//  MoviesSectionViewModel.swift
//  ReactiveMovies
//
//  Created by Maciej Krolikowski on 12/10/2020.
//  Copyright © 2020 Maciej Krolikowski. All rights reserved.
//

import SwiftUI
import Combine

final class MoviesSectionViewModel: ObservableObject {
        
    @Published var moviesViewModels: [MovieViewModel] = []
    
    @ObservedObject var typedText: TypedText = TypedText()
    
    private var fetchedData: [MovieDTO] = []
    
    private var subscriptions = Set<AnyCancellable>()
    
    private var currentPage = 1
    
    @Published var searchedMovie: [MovieDTO] = []
    
    var isSearching: Bool {
        return typedText.value.count > 0
    }
    
    init() {
        fetchMovies(page: 1)
        
        typedText.$value
            .filter({ (value) -> Bool in
                if value.isEmpty {
                    self.moviesViewModels = self.fetchedData.map { MovieViewModel(movie: $0) }
                    return false
                }
                return true
            })
            .handleEvents(receiveOutput: { text in
                print(text)
            })
            .flatMap{ typedText -> AnyPublisher<PaginatedResponse<MovieDTO>, APIService.APIError> in
                return MoviesDBService.shared.searchMovie(text: typedText)
            }
            .replaceError(with: PaginatedResponse<MovieDTO>(page: nil, totalResults: nil, totalPages: nil, results: []))
            .map(\.results)
            .receive(on: DispatchQueue.main)
            .map { movies in movies.map { MovieViewModel(movie: $0) }  }
            .assign(to: \.moviesViewModels, on: self)
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
                let currentMoviesIds = self.fetchedData.map { $0.id }
                self.fetchedData += response.results.filter { !currentMoviesIds.contains($0.id) }
                self.currentPage = response.page ?? 0
                self.moviesViewModels = self.fetchedData.map { MovieViewModel(movie: $0) }
            })
        .store(in: &subscriptions)
    }
}
