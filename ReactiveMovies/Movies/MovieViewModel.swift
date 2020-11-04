//
//  MovieViewModel.swift
//  ReactiveMovies
//
//  Created by Maciej Krolikowski on 03/11/2020.
//  Copyright © 2020 Maciej Krolikowski. All rights reserved.
//

import SwiftUI
import Combine

class MovieViewModel: ObservableObject, Identifiable {
    @State var height: CGFloat = 170
    @ObservedObject var imageLoader: AsynchronousImageLoader
    
    var movie: MovieDTO
    var id: Int { movie.id }
    
    init(movie: MovieDTO) {
        self.movie = movie
        self.imageLoader = ImageLoadersCache.share.create(imagePath: movie.posterPath, size: .movie)
    }
}
