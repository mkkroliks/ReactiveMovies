//
//  ContentView.swift
//  ReactiveMovies
//
//  Created by Maciej Krolikowski on 08/04/2020.
//  Copyright © 2020 Maciej Krolikowski. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    var movies: [Movie]
    
    var body: some View {
        List {
            Section {
                SeachTextField()
            }
            Section {
                MoviesSection(movies: movies)
            }
        }
    }
}

struct MoviesSection: View {
        
    @ObservedObject var viewModel: MoviesSectionViewModel
    
    var body: some View {
        ForEach(viewModel.movies) { movie in
            MovieCell(movie: movie)
        }
    }
    
    init(movies: [Movie]) {
        viewModel = MoviesSectionViewModel(movies: movies)
    }
}

public final class MoviesSectionViewModel: ObservableObject {
    
    @Published var movies: [Movie]
    
    private var subscriptions = Set<AnyCancellable>()
    
    var typedValue: AnyPublisher<String, Never> = CurrentValueSubject("Movie 1").eraseToAnyPublisher()
    
    init(movies: [Movie]) {
        self.movies = movies
        
        typedValue
            .flatMap { typedString -> Result<[Movie], Never>.Publisher in
                let movies = movies.filter { $0.title.contains(typedString) }
                return movies.publisher.collect()
            }
            .assign(to: \.movies, on: self)
            .store(in: &subscriptions)
    }
}

struct SeachTextField: View {
    
    @State var typedText: String = ""
    
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: "magnifyingglass.circle")
            TextField("Search for a movie", text: $typedText)
        }
    }
}

struct MovieCell: View {
    
    let movie: Movie
    
    var body: some View {
        
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 10) {
                Text(movie.title)
                Text(movie.description)
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
        ContentView(movies: MoviesFactory.make())
    }
}
