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
    var movies: [Movie]
    
    @ObservedObject var typedText: TypedText = TypedText()
    
    var body: some View {
        List {
            Section {
                SeachTextField(typedText: $typedText.value)
            }
            Section {
                MoviesSection(movies: movies, typedText: _typedText)
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
    
    init(movies: [Movie], typedText: ObservedObject<TypedText>) {
        viewModel = MoviesSectionViewModel(movies: movies, observedObject: typedText)
    }
}

public final class MoviesSectionViewModel: ObservableObject {
    
    @Published var movies: [Movie]
    
    private var subscriptions = Set<AnyCancellable>()
    
    @ObservedObject var typedText: TypedText
    
    init(movies: [Movie], observedObject: ObservedObject<TypedText>) {
        self.movies = movies
        self._typedText = observedObject
        
        typedText.$value
            .flatMap { typedString -> Result<[Movie], Never>.Publisher in
                if typedString.count > 0 {
                    let movies = movies.filter { $0.title.contains(typedString) }
                    return movies.publisher.collect()
                } else {
                    return movies.publisher.collect()
                }
            }
            .assign(to: \.movies, on: self)
            .store(in: &subscriptions)
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
