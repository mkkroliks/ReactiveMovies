//
//  MovieDetailsHeader.swift
//  ReactiveMovies
//
//  Created by Maciej Krolikowski on 25/04/2020.
//  Copyright © 2020 Maciej Krolikowski. All rights reserved.
//

import SwiftUI
import Combine

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
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {}
}

class MovieDetailsHeaderViewModel: ObservableObject {
    
    var releaseDate: String {
        guard let productionDate = movie.releaseDate else {
            return ""
        }
        let calendar = Calendar.current
        return "(" + String(calendar.component(.year, from: productionDate)) + ")"
    }
    
    @Published var trailer: Video?
    
    private var subscriptions = Set<AnyCancellable>()
    
    @ObservedObject var imageLoader: AsynchronousImageLoader
    
    let movie: MovieDTO
    
    init(movie: MovieDTO) {
        imageLoader =  ImageLoadersCache.share.create(imagePath: movie.posterPath, size: .medium)
        self.movie = movie
    }
    
    func fetchData() {
        MoviesDBService.shared.getMovieVideos(id: String(movie.id))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: { videos in
                self.trailer = videos.trailer
            })
            .store(in: &subscriptions)
    }
}

struct MovieDetailsHeader: View {
    
    @ObservedObject var viewModel: MovieDetailsHeaderViewModel
        
    private var onTapPoster: ((CGRect) -> Void)?
    
    private var viewsValues = MovieDetailsHeaderValues()
    
    init(viewModel: MovieDetailsHeaderViewModel, onTapPoster: ((CGRect) -> Void)? = nil) {
        self.viewModel = viewModel
        self.onTapPoster = onTapPoster
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text(viewModel.movie.title)
                        .font(Font.title.bold())
                        .foregroundColor(.white)
                    Spacer()
                }
                HStack(alignment: .top) {
                        MoviePosterImage(imageLoader: viewModel.imageLoader)
                            .background(GeometryReader { reader in
                                assignValue(for: reader)
                            })
                            .onPreferenceChange(PosterFramePreferenceKey.self, perform: { position in
                                self.viewsValues.posterPosition = position
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
                            Text(viewModel.movie.overview)
                                .foregroundColor(.white)
                                .font(Font.caption)
                            HStack {
                                RatingView(percent: viewModel.movie.voteAverage * 10)
                                Text("Users\nScore")
                                    .foregroundColor(.white)
                                    .font(Font.caption.bold())
                            }
                        }
                        Spacer()
                }
            }
        }
        .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
        .background(MovieDetailsBlurredImage(imageLoader: viewModel.imageLoader))
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
