//
//  MovieView.swift
//  ReactiveMovies
//
//  Created by Maciej Krolikowski on 12/10/2020.
//  Copyright © 2020 Maciej Krolikowski. All rights reserved.
//

import SwiftUI
import Combine

struct MovieView: View {
    
    var movie: MovieDTO
    
    private let imageAspectRatio: CGFloat = 1.5
    
    @State private var height: CGFloat = 170
    
    var body: some View {
        ZStack(alignment: .ratingAndPosterAlignment) {
            VStack(alignment: .leading, spacing: 0) {
                MovieImage(imageLoader: AsynchronousImageLoader(imagePath: self.movie.posterPath, size: .movie))
                    .frame(height: height)
                    .alignmentGuide(.ratingAndPosterVerticalAlignment) { dimension in
                        dimension[.bottom]
                    }
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 1) {
                        Text(self.movie.title)
                            .foregroundColor(.black)
                            .font(.system(size: 10)).bold()
                            .lineLimit(1)
                        Text(self.movie.releaseDate?.toMoviePosterDateString() ?? "")
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
                height = imageAspectRatio * ($0 ?? 0)
            })
            .cornerRadius(10)
            .shadow(color: Color.gray.opacity(0.3), radius: 6)
            
            RatingView(percentToShow: self.movie.voteAverage * 10, animate: false)
                .alignmentGuide(.ratingAndPosterHorizontalAlignment) { dimension in
                    dimension[.leading]
                }
                .alignmentGuide(.ratingAndPosterVerticalAlignment) { dimension in
                    dimension[VerticalAlignment.center]
                }
        }
    }
}

struct MovieView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            MovieView(movie: MovieDTOFactory.make()).frame(width: 100, height: 250)
        }
    }
}
