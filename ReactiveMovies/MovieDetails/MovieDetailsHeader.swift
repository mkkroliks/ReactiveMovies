//
//  MovieDetailsHeader.swift
//  ReactiveMovies
//
//  Created by Maciej Krolikowski on 25/04/2020.
//  Copyright © 2020 Maciej Krolikowski. All rights reserved.
//

import SwiftUI

struct DateFormatters {
    static let moviePosterDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter
    }()
}

extension Date {
    func toMoviePosterDateString() -> String {
        DateFormatters.moviePosterDateFormatter.string(from: self)
    }
}

struct MovieDetailsHeader: View {
    
    @ObservedObject var imageLoader: AsynchronousImageLoader
    
    @ObservedObject var viewModel: MovieDetailsHeaderViewModel
        
    var releaseDate: String {
        guard let productionDate = movie.releaseDate else {
            return ""
        }
        let calendar = Calendar.current
        return "(" + String(calendar.component(.year, from: productionDate)) + ")"
    }
    
    var movie: MovieDTO
    
    init(imageLoader: AsynchronousImageLoader, movie: MovieDTO) {
        self.movie = movie
        self.imageLoader = imageLoader
        viewModel = MovieDetailsHeaderViewModel(id: String(movie.id))
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text(self.movie.title)
                        .font(Font.title.bold())
                        .foregroundColor(.white)
                    Spacer()
                }
                HStack(alignment: .top) {
                        MoviePosterImage(imageLoader: self.imageLoader)
                        VStack(alignment: .leading) {
                            if let viewModel = viewModel.trailer {
                                Link(destination: URL(string: "https://www.youtube.com/watch?v=\(viewModel.key)")!, label: {
                                    HStack {
//                                        Image(systemName: "play.rectangle")
                                        Image(systemName: "play.fill")
                                        Text("Watch trailer")
                                    }
                                    .foregroundColor(Color("SegmentedControlGradientStart"))
                                    .padding(EdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 6))
                                    .border(Color("SegmentedControlGradientStart"), width: 1)
                                })
                            }
                            Text("Overview")
                                .foregroundColor(.white)
                                .font(Font.subheadline.bold())
                                .padding(.bottom, 5)
                            Text(self.movie.overview)
                                .foregroundColor(.white)
                                .font(Font.caption)
                            HStack {
                                RatingView(percentToShow: movie.voteAverage * 10)
                                Text("User\nScore")
                                    .foregroundColor(.white)
                                    .font(Font.caption.bold())
                            }
                        }
                        Spacer()
                }
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
