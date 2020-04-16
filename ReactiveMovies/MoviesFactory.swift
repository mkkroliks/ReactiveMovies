//
//  MoviesFactory.swift
//  ReactiveMovies
//
//  Created by Maciej Krolikowski on 09/04/2020.
//  Copyright © 2020 Maciej Krolikowski. All rights reserved.
//

import Foundation

enum MoviesFactory {
    static func make() -> [MovieDTO] {
        [
            MovieDTO(id: 0,title: "Movie 1", overview: "Overview"),
            MovieDTO(id: 1,title: "Movie 2", overview: "Overview"),
            MovieDTO(id: 2,title: "Movie 3", overview: "Overview"),
            MovieDTO(id: 3,title: "Movie 4", overview: "Overview"),
            MovieDTO(id: 4,title: "Movie 5", overview: "Overview"),
            MovieDTO(id: 5,title: "Movie 6", overview: "Overview"),
            MovieDTO(id: 6,title: "Movie 7", overview: "Overview"),
            MovieDTO(id: 7,title: "Movie 8", overview: "Overview"),
            MovieDTO(id: 8,title: "Movie 9", overview: "Overview"),
            MovieDTO(id: 9,title: "Movie 10", overview: "Overview")
        ]
    }
}
