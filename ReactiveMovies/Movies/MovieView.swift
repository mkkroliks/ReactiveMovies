//
//  MovieView.swift
//  ReactiveMovies
//
//  Created by Maciej Krolikowski on 12/10/2020.
//  Copyright © 2020 Maciej Krolikowski. All rights reserved.
//

import SwiftUI
import Combine

struct Constants {
    static let imageAspectRatio: CGFloat = 1.5
}

class MovieViewModel: ObservableObject, Identifiable {
    @State var height: CGFloat = 170
    @ObservedObject var imageLoader: AsynchronousImageLoader
    
    var movie: MovieDTO
    var id: Int { movie.id }
    
    init(movie: MovieDTO) {
        self.movie = movie
        self.imageLoader = AsynchronousImageLoader(imagePath: movie.posterPath, size: .movie)
    }
}

struct MovieView: View {
    @ObservedObject var viewModel: MovieViewModel
    
    init(viewModel: MovieViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack(alignment: .ratingAndPosterAlignment) {
            VStack(alignment: .leading, spacing: 0) {
                MovieImage(imageLoader: viewModel.imageLoader)
                    .frame(height: viewModel.height)
                    .alignmentGuide(.ratingAndPosterVerticalAlignment) { dimension in
                        dimension[.bottom]
                    }
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 1) {
                        Text(viewModel.movie.title)
                            .foregroundColor(.black)
                            .font(.system(size: 10)).bold()
                            .lineLimit(1)
                        Text(viewModel.movie.releaseDate?.toMoviePosterDateString() ?? "")
                            .foregroundColor(.black)
                            .font(.system(size: 10))
                    }
                    .alignmentGuide(.ratingAndPosterHorizontalAlignment) { dimension in
                        dimension[.leading]
                    }
                }
                .padding(EdgeInsets(top: 30, leading: 8, bottom: 10, trailing: 8))
            }
            .background(GeometryReader { reader in
                Color.white.preference(key: WidthKey.self, value: reader.size.width)
            })
            .onPreferenceChange(WidthKey.self, perform: {
                viewModel.height = Constants.imageAspectRatio * ($0 ?? 0)
            })
            .cornerRadius(10)
            .shadow(color: Color.gray.opacity(0.3), radius: 6)
            
            RatingView(percentToShow: viewModel.movie.voteAverage * 10, animate: false)
                .alignmentGuide(.ratingAndPosterHorizontalAlignment) { dimension in
                    dimension[.leading]
                }
                .alignmentGuide(.ratingAndPosterVerticalAlignment) { dimension in
                    dimension[VerticalAlignment.center]
                }
        }
    }
}

//struct MovieView_Previews: PreviewProvider {
//    static var previews: some View {
//        ZStack {
//            MovieView(movie: MovieDTOFactory.make()).frame(width: 100, height: 250)
//        }
//    }
//}
