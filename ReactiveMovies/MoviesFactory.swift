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
            MovieDTO(id: 0,title: "Movie 1"),
            MovieDTO(id: 1,title: "Movie 2"),
            MovieDTO(id: 2,title: "Movie 3"),
            MovieDTO(id: 3,title: "Movie 4"),
            MovieDTO(id: 4,title: "Movie 5"),
            MovieDTO(id: 5,title: "Movie 6"),
            MovieDTO(id: 6,title: "Movie 7"),
            MovieDTO(id: 7,title: "Movie 8"),
            MovieDTO(id: 8,title: "Movie 9"),
            MovieDTO(id: 9,title: "Movie 10")
        ]
    }
}
