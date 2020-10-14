//
//  MovieDetails.swift
//  ReactiveMovies
//
//  Created by Maciej Krolikowski on 19/04/2020.
//  Copyright © 2020 Maciej Krolikowski. All rights reserved.
//

import SwiftUI
import Combine

class MovieDetailsHeaderViewModel: ObservableObject {
    
    @Published var trailer: Video?
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(id: String) {
        MoviesDBService.shared.getMovieVideos(id: id)
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

class PosterPosition: ObservableObject {
    @Published var value: CGRect = .zero
}

struct MovieDetails: View {
    var movie: MovieDTO
    
    @State var isShowingContent = false
    
    @State var posterPosition = CGRect.zero
    
    @State var startPosterAnimation = false
    
    private var subscriptions = Set<AnyCancellable>()
    
    var releaseDate: String {
        guard let productionDate = movie.releaseDate else {
            return ""
        }
        let calendar = Calendar.current
        return "(" + String(calendar.component(.year, from: productionDate)) + ")"
    }
    
    init(movie: MovieDTO) {
        self.movie = movie
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            ScrollView {
                if isShowingContent {
                    MovieDetailsHeader(imageLoader: AsynchronousImageLoader(imagePath: movie.posterPath, size: .medium), movie: movie) { posterPosition in
                        self.posterPosition = posterPosition
                        self.startPosterAnimation = false
                        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
                            self.posterPosition = CGRect(x: 15, y: 15, width: UIScreen.main.bounds.width - 30, height: 500)
                            self.startPosterAnimation = true
                        }
                    }
                    CastsView(viewModel: CastViewModel(movieId: movie.id))
                        .frame(height: 200)
                    Text("Move details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\n")
                    Spacer()
                }
            }
            MoviePosterImageResizable(imageLoader: AsynchronousImageLoader(imagePath: movie.posterPath, size: .medium))
                .frame(width: posterPosition.width, height: posterPosition.height)
                .offset(x: posterPosition.origin.x, y: posterPosition.origin.y)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: posterPosition.origin.y, trailing: posterPosition.origin.x))
                .clipped()
                .aspectRatio(contentMode: .fit)
                .animation(startPosterAnimation ? .default : nil)
        }
        .onPreferenceChange(PosterFramePreferenceKey.self, perform: {
            print("🩸 Preference changed \($0)")
        })
        .navigationBarTitle(movie.title, displayMode: .inline)
        .coordinateSpace(name: "MovieDetails.main")
        .onAppear {
            self.isShowingContent = true
        }
    }
    
}
