//
//  MovieDetails.swift
//  ReactiveMovies
//
//  Created by Maciej Krolikowski on 19/04/2020.
//  Copyright © 2020 Maciej Krolikowski. All rights reserved.
//

import SwiftUI
import Combine

struct MovieDetails: View {
    var movie: MovieDTO
    
    var releaseDate: String {
        guard let productionDate = movie.releaseDate else {
            return ""
        }
        let calendar = Calendar.current
        return "(" + String(calendar.component(.year, from: productionDate)) + ")"
    }
    
    var body: some View {
        List {
            Section {
                MovieDetailsHeader(imageLoader: AsynchronousImageLoader(imagePath: movie.posterPath, size: .medium), movie: movie)
                .listRowInsets(EdgeInsets())
            }
            CastsView(viewModel: CastViewModel(movieId: movie.id))
                .frame(height: 200)
            Text("Move details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\n")
            Spacer()
        }
        .navigationBarTitle(Text("\(movie.title) \(releaseDate)").foregroundColor(.red), displayMode: .large)
        .edgesIgnoringSafeArea(.top)
    }
    
}
