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

struct MovieDetails: View {
    var movie: MovieDTO
    @State var trailer: Video?
    
    var releaseDate: String {
        guard let productionDate = movie.releaseDate else {
            return ""
        }
        let calendar = Calendar.current
        return "(" + String(calendar.component(.year, from: productionDate)) + ")"
    }
    
    var body: some View {
        ScrollView {
            MovieDetailsHeader(imageLoader: AsynchronousImageLoader(imagePath: movie.posterPath, size: .medium), movie: movie)
            CastsView(viewModel: CastViewModel(movieId: movie.id))
                .frame(height: 200)
            Text("Move details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\n")
            Spacer()
        }
        .navigationBarTitle(movie.title, displayMode: .inline)
    }
    
}
