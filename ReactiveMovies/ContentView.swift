//
//  ContentView.swift
//  ReactiveMovies
//
//  Created by Maciej Krolikowski on 08/04/2020.
//  Copyright © 2020 Maciej Krolikowski. All rights reserved.
//

import SwiftUI
import Combine

class TypedText: ObservableObject {
    @Published var value: String = ""
}

struct ContentView: View {
    
    @ObservedObject var viewModel = MoviesSectionViewModel()
    
    var body: some View {
        List {
            Section {
                SeachTextField(typedText: viewModel.$typedText.value)
            }
            Section {
                MoviesSection(viewModel: viewModel)
            }
            if viewModel.movies.isEmpty == false {
                Rectangle()
                    .foregroundColor(.clear)
                    .onAppear {
                        if !self.viewModel.movies.isEmpty, !self.viewModel.isSearching {
                            self.viewModel.fetchNextPage()
                        }
                    }
            }
        }
        
    }
}

public final class MoviesSectionViewModel: ObservableObject {
    
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
            .flatMap { typedString -> Result<[MovieDTO], Never>.Publisher in
                if typedString.count > 0 {
                    let movies = self.fetchedData.filter { $0.title.contains(typedString) }
                    return movies.publisher.collect()
                } else {
                    return self.fetchedData.publisher.collect()
                }
            }
            .print()
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

struct MoviesSection: View {
        
    @ObservedObject var viewModel: MoviesSectionViewModel
    
    var body: some View {
        ForEach(viewModel.movies) { movie in
            MovieCell(movie: movie)
        }
    }
}

struct SeachTextField: View {

    @Binding var typedText: String

    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: "magnifyingglass.circle")
            TextField("Search for a movie", text: $typedText)
        }
    }
}

struct MovieCell: View {
    
    let movie: MovieDTO
    
    var body: some View {
        
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 10) {
                Text(movie.title)
                Text(movie.overview)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
            }
            Spacer()
            Image(systemName: "tv")
                .frame(width: 80, height: 80, alignment: .center)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
