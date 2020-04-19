//
//  MovieDetails.swift
//  ReactiveMovies
//
//  Created by Maciej Krolikowski on 19/04/2020.
//  Copyright © 2020 Maciej Krolikowski. All rights reserved.
//

import SwiftUI

struct MovieDetails: View {
    var movie: MovieDTO
    
    var body: some View {
        VStack {
            MovieDetailsHeader(imageLoader: AsynchronousImageLoader(imagePath: movie.posterPath, size: .medium), movie: movie)
            Text("Move details")
            Spacer()
        }   
    }
}
