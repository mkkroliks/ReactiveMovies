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

struct MoviesView: View {
    
    @ObservedObject var viewModel = MoviesSectionViewModel()
    
    var numberOfElementsInRow = 3
    
    let layout = [
        GridItem(.adaptive(minimum: 105), spacing: 15)
    ]
    
    var elementCount = 0
    var currentRow = 0
    
    var body: some View {
        NavigationView {
            ScrollView {
                Divider()
                MoviesSeachTextField(typedText: viewModel.$typedText.value)
                    .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
                Divider()
                HStack {
                    SegmentedControlView(value: $viewModel.selectedSegmentedControlerItem)
                    Spacer()
                }
                .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
                Divider()
                LazyVGrid(columns: layout, spacing: 20) {
                    ForEach(viewModel.moviesViewModels) { cellViewModel in
                        NavigationLink(destination: MovieDetails(movie: cellViewModel.movie)) {
                            MovieView(viewModel: cellViewModel)
                        }.buttonStyle(PlainButtonStyle())
                    }
                    Rectangle()
                        .foregroundColor(.clear)
                        .onAppear {
                            if !self.viewModel.moviesViewModels.isEmpty, !self.viewModel.isSearching {
                                self.viewModel.fetchNextPage()
                            }
                        }
                }
                .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
            }
            .navigationBarTitle(Text("Movies"), displayMode: .large)
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
        MoviesView()
    }
}
