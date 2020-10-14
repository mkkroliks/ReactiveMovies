//
//  Movies.swift
//  ReactiveMovies
//
//  Created by Maciej Krolikowski on 14/05/2020.
//  Copyright © 2020 Maciej Krolikowski. All rights reserved.
//

import SwiftUI
import Combine
import Foundation

struct WidthKey: PreferenceKey {
    static let defaultValue: CGFloat? = nil
    static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
        value = value ?? nextValue()
    }
}

extension VerticalAlignment {
    enum RatingAndPoster: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[.top]
        }
    }
    
    static let ratingAndPosterVerticalAlignment = VerticalAlignment(RatingAndPoster.self)
}

extension HorizontalAlignment {
    enum RatingAndPoster: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[.leading]
        }
    }
    
    static let ratingAndPosterHorizontalAlignment = HorizontalAlignment(RatingAndPoster.self)
}

extension Alignment {
    static let ratingAndPosterAlignment = Alignment(horizontal: .ratingAndPosterHorizontalAlignment, vertical: .ratingAndPosterVerticalAlignment)
}

struct MoviesSeachTextField: View {

    @Binding var typedText: String

    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: "magnifyingglass.circle")
            TextField("Search for a movie", text: $typedText)
        }
    }
}

struct Movies: View {
    
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
                LazyVGrid(columns: layout, spacing: 20) {
                    ForEach(viewModel.movies) { movie in
                        NavigationLink(destination: MovieDetails(movie: movie)) {
                            MovieView(movie: movie)
                        }.buttonStyle(PlainButtonStyle())
                    }
                    Rectangle()
                        .foregroundColor(.clear)
                        .onAppear {
                            if !self.viewModel.movies.isEmpty, !self.viewModel.isSearching {
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

//struct MoviesView_Previews: PreviewProvider {
//    static let viewModel: MoviesSectionViewModel = {
//        let viewModel = MoviesSectionViewModel()
//        viewModel.movies = []
//        return viewModel
//    }()
//
//    static var previews: some View {
//        Movies(viewModel: viewModel)
//    }
//}
