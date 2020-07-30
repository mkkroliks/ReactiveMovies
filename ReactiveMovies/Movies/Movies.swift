//
//  Movies.swift
//  ReactiveMovies
//
//  Created by Maciej Krolikowski on 14/05/2020.
//  Copyright © 2020 Maciej Krolikowski. All rights reserved.
//

import SwiftUI

struct WidthKey: PreferenceKey {
    static let defaultValue: CGFloat? = nil
    static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
        value = value ?? nextValue()
    }
}

struct MovieImage: View {
    @ObservedObject var imageLoader: AsynchronousImageLoader
    
    var body: some View {
        GeometryReader { reader in
            ZStack {
                if imageLoader.image != nil {
                    Image(uiImage: imageLoader.image!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: reader.size.width, height: reader.size.height)
                } else {
                    Rectangle()
                }
            }
            .clipped()
        }
    }
}

struct MovieView: View {
    
    var movie: MovieDTO
    
    private let imageAspectRatio: CGFloat = 1.5
    
    @State private var height: CGFloat = 170
    
    var body: some View {
        VStack(alignment: .leading) {
            MovieImage(imageLoader: AsynchronousImageLoader(imagePath: self.movie.posterPath, size: .movie))
                .frame(height: height)
            RatingView(percentToShow: self.movie.voteAverage * 10, animate: false)
            VStack(alignment: .leading, spacing: 1) {
                Text(self.movie.title)
                    .foregroundColor(.black)
                    .font(.system(size: 10)).bold()
                    .lineLimit(1)
                Text(self.movie.releaseDateText)
                    .foregroundColor(.black)
                    .font(.system(size: 10))
            }
            .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
        }
        .background(GeometryReader { reader in
            Color.white.preference(key: WidthKey.self, value: reader.size.width)
        })
        .onPreferenceChange(WidthKey.self, perform: {
            height = imageAspectRatio * ($0 ?? 0)
            
        })
        .cornerRadius(10)
        .shadow(color: Color.gray.opacity(0.3), radius: 6)
    }
}

struct MovieView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            MovieView(movie: MovieDTOFactory.make()).frame(width: 100, height: 250)
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
                LazyVGrid(columns: layout, spacing: 20) {
                    ForEach(viewModel.movies) { movie in
                        NavigationLink(destination: MovieDetails(movie: movie)) {
                            MovieView(movie: movie)
                        }.buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
            }
            .navigationBarTitle(Text("Movies"), displayMode: .large)
        }
    }
    private func getView(for row: Int, column: Int) -> some View {
        let index = row * self.numberOfElementsInRow + column
        guard index < self.viewModel.movies.count else {
            return AnyView(EmptyView())
        }
        let movie = self.viewModel.movies[row * self.numberOfElementsInRow + column]
        return AnyView(
            NavigationLink(destination: MovieDetails(movie: movie)) {
                MovieView(movie: movie)
            }.buttonStyle(PlainButtonStyle())
        )
    }
}

struct MoviesView_Previews: PreviewProvider {
    static let viewModel: MoviesSectionViewModel = {
        let viewModel = MoviesSectionViewModel()
        viewModel.movies = []
        return viewModel
    }()
    
    static var previews: some View {
        Movies(viewModel: viewModel)
    }
}

struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content

    var body: some View {
        VStack {
            ForEach(0 ..< rows, id: \.self) { row in
                HStack {
                    ForEach(0 ..< self.columns, id: \.self) { column in
                        self.content(row, column)
                    }
                }
            }
        }
    }

    init(rows: Int, columns: Int, @ViewBuilder content: @escaping (Int, Int) -> Content) {
        self.rows = rows
        self.columns = columns
        self.content = content
    }
}
