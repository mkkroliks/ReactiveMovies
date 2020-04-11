//
//  MoviesFactory.swift
//  ReactiveMovies
//
//  Created by Maciej Krolikowski on 09/04/2020.
//  Copyright © 2020 Maciej Krolikowski. All rights reserved.
//

import Foundation

enum MoviesFactory {
//    static func make() -> [Movie] {
//        [
//            Movie(title: "Movie 1", description: "Some Common description"),
//            Movie(title: "Movie 2", description: "Some Common description"),
//            Movie(title: "Movie 3", description: "Some Common description"),
//            Movie(title: "Movie 4", description: "Some Common description"),
//            Movie(title: "Movie 5", description: "Some Common description"),
//            Movie(title: "Movie 6", description: "Some Common description"),
//            Movie(title: "Movie 7", description: "Some Common description"),
//            Movie(title: "Movie 8", description: "Some Common description"),
//            Movie(title: "Movie 9", description: "Some Common description"),
//            Movie(title: "Movie 10", description: "Some Common description")
//        ]
//    }
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
