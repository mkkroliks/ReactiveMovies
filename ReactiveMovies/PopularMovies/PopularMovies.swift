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

struct PopularMovies: View {
    
    @ObservedObject var viewModel = PopularMoviesSectionViewModel()
    
    var body: some View {

        NavigationView {
            List {
                Section {
                    HStack {
                        Spacer()
                        SegmentedControllView()
                        Spacer()
                    }
                }
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
            .navigationBarTitle(Text("Popular Movies"))
        }
    }
}

struct MoviesSection: View {
        
    @ObservedObject var viewModel: PopularMoviesSectionViewModel
    
    var body: some View {
        ForEach(viewModel.movies) { movie in
            NavigationLink(destination: MovieDetails(movie: movie)) {
                PopularMovieView(movie: movie)
            }
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


struct PopularMovies_Previews: PreviewProvider {
    static var previews: some View {
        PopularMovies()
    }
}
