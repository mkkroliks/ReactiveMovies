//
//  MovieDetailsHeader.swift
//  ReactiveMovies
//
//  Created by Maciej Krolikowski on 25/04/2020.
//  Copyright © 2020 Maciej Krolikowski. All rights reserved.
//

import SwiftUI

struct MovieDetailsHeader: View {
    
    @ObservedObject var imageLoader: AsynchronousImageLoader
        
    var releaseDate: String {
        guard let productionDate = movie.releaseDate else {
            return ""
        }
        let calendar = Calendar.current
        return "(" + String(calendar.component(.year, from: productionDate)) + ")"
    }
    
    var movie: MovieDTO
    
    var body: some View {
        ZStack {
                HStack(alignment: .top) {
                    MoviePosterImage(imageLoader: self.imageLoader)
                    VStack(alignment: .leading) {
                        HStack {
                            Text(self.movie.title)
                                .foregroundColor(.white)
                                .font(Font.headline.bold())
                            Text(self.releaseDate)
                                .foregroundColor(.white)
                                .font(Font.headline.weight(.light))
                        }
                        .padding(.bottom, 15)
                        Text("Overview")
                            .foregroundColor(.white)
                            .font(Font.subheadline.bold())
                            .padding(.bottom, 5)
                        Text(self.movie.overview)
                            .foregroundColor(.white)
                            .font(Font.caption)
                        RatingView(percentToShow: movie.voteAverage * 10)
                    }
                    Spacer()
                }
        }
        .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
        .background(MovieDetailsBlurredImage(imageLoader: imageLoader))
        .clipped()
    }
}

struct MovieDetailsHeader_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailsHeader(imageLoader: ImageLoaderMock(image: UIImage(named: "parasite")!),
                           movie: MovieDTOFactory.make(overview: "All unemployed, Ki-taek's family takes peculiar interest in the wealthy and glamorous Parks for their livelihood until they get entangled in an unexpected incident.", title: "Parasite"))
    }
}
