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
    
//    @ObservedObject var typedText: TypedText = TypedText()
    
    @ObservedObject var viewModel = MoviesSectionViewModel()
    
    var body: some View {
        List {
            Section {
                SeachTextField(typedText: viewModel.$typedText.value)
            }
            Section {
                MoviesSection(viewModel: viewModel)
            }
        }
        
    }
}

public final class MoviesSectionViewModel: ObservableObject {
    
    @Published var movies: [MovieDTO] = []
    
    @Published private var fetchedData: [MovieDTO] = []
    
    @ObservedObject var typedText: TypedText = TypedText()
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        
        $movies.sink { movies in
            print("MOVIES: \(movies)")
        }.store(in: &subscriptions)
        
        MoviesDBService.shared
            .getPopular()
            .replaceError(with: [])
            .sink(receiveValue: { models in
                self.movies = models
                self.fetchedData = models
            })
//            .assign(to: \.movies, on: self)
            .store(in: &subscriptions)
        
        typedText.$value
            .flatMap { typedString -> Result<[MovieDTO], Never>.Publisher in
                if typedString.count > 0 {
                    let movies = self.movies.filter { $0.title.contains(typedString) }
                    return movies.publisher.collect()
                } else {
//                    return self.movies.publisher.collect()
                    return self.fetchedData.publisher.collect()
                }
            }
            .print()
            .assign(to: \.movies, on: self)
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
//                Text(movie.description)
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
