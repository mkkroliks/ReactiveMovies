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

class MovieDetailsHeaderValues {
    var posterPosition: CGRect = .zero
}

struct PosterFramePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = CGRect(x: 1, y: 1, width: 1, height: 1)
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
//        let changed = value + 1
//        let changedValue = value
//        value = CGRect(x: value.minX + 1, y: value.minY + 1, width: value.width, height: value.height)
//        value = changedValue
//        value = nextValue()
//        let newValue = nextValue()
//        value = newValue
    }
    
//    typealias Value = CGRect
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
    
    var onTapPoster: ((CGRect) -> Void)?
    
    var viewsValues = MovieDetailsHeaderValues()
    
    init(imageLoader: AsynchronousImageLoader, movie: MovieDTO, onTapPoster: ((CGRect) -> Void)? = nil) {
        self.movie = movie
        self.imageLoader = imageLoader
        self.onTapPoster = onTapPoster
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
                            .background(GeometryReader { reader in
                                assignValue(for: reader)
                            })
                            .onPreferenceChange(PosterFramePreferenceKey.self, perform: { position in
                                self.viewsValues.posterPosition = position
                                print("🟢 Preference changed \(position)")
                            }).onTapGesture {
                                onTapPoster?(viewsValues.posterPosition)
                            }
                        VStack(alignment: .leading) {
                            if let viewModel = viewModel.trailer {
                                Link(destination: URL(string: "https://www.youtube.com/watch?v=\(viewModel.key)")!, label: {
                                    HStack {
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
    
    private func assignValue(for reader: GeometryProxy) -> some View {
        let frame = reader.frame(in: .named("MovieDetails.main"))
        viewsValues.posterPosition = frame
        return Color.clear.preference(key: PosterFramePreferenceKey.self, value: frame)
    }
}

//struct MovieDetailsHeader_Previews: PreviewProvider {
//    static var previews: some View {
//        MovieDetailsHeader(imageLoader: ImageLoaderMock(image: UIImage(named: "parasite")!),
//                           movie: MovieDTOFactory.make(overview: "All unemployed, Ki-taek's family takes peculiar interest in the wealthy and glamorous Parks for their livelihood until they get entangled in an unexpected incident.", title: "Parasite"), posterPosition: .zero)
//    }
//}
