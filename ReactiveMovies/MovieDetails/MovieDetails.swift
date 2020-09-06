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
    
//    @ObservedObject var posterPosition = PosterPosition()
    
//    @ObservedObject var posterPosition = PosterPosition()
    
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
//        posterPosition
//            .objectWillChange
//            .sink(receiveCompletion: { completion in
//                switch completion {
//                case .finished:
//                    break
//                case .failure(let error):
//                    print(error)
//                }
//            }, receiveValue: { response in
//                print(response)
////                print(self.posterPosition.value)
//            })
//        .store(in: &subscriptions)
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            ScrollView {
                if isShowingContent {
                    MovieDetailsHeader(imageLoader: AsynchronousImageLoader(imagePath: movie.posterPath, size: .medium), movie: movie) { posterPosition in
                        self.posterPosition = posterPosition
                        self.startPosterAnimation = false
                        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: false) { (timer) in
                            self.posterPosition = CGRect(x: 15, y: 15, width: UIScreen.main.bounds.width - 30, height: 300)
                            self.startPosterAnimation = true
                        }
                    }
                    CastsView(viewModel: CastViewModel(movieId: movie.id))
                        .frame(height: 200)
                    Text(posterPosition.debugDescription)
                    Text("details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\n")
                    Spacer()
                }
            }
                Print(posterPosition.origin.x)
                Print(posterPosition.origin.y)
            
            Image(uiImage: UIImage(named: "parasite")!)
                .frame(width: posterPosition.width, height: posterPosition.height)
                .aspectRatio(contentMode: .fill)
                .clipped()
                .opacity(startPosterAnimation ? 1 : 0)
                .offset(x: posterPosition.origin.x, y: posterPosition.origin.y)
                .animation(.easeInOut(duration: 1.0), value: self.startPosterAnimation)
            
            // working
//                Rectangle()
//                    .frame(width: posterPosition.width, height: posterPosition.height)
//                    .offset(x: posterPosition.origin.x, y: posterPosition.origin.y)
//                    .animation(.easeInOut(duration: 1.0), value: self.startPosterAnimation)
        }
//        .alignmentGuide(.top) { _ in
//
//        }
//        .alignmentGuide(.leading) { _ in
//
//        }
//        .onPreferenceChange(PosterFramePreferenceKey.self) { print("FRAME: \($0)") }
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
