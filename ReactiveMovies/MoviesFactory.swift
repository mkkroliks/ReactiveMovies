//
//  MoviesFactory.swift
//  ReactiveMovies
//
//  Created by Maciej Krolikowski on 09/04/2020.
//  Copyright © 2020 Maciej Krolikowski. All rights reserved.
//

import Foundation

enum MoviesFactory {
    static func make() -> [Movie] {
        [
            Movie(title: "Movie 1", description: "Some Common description"),
            Movie(title: "Movie 2", description: "Some Common description"),
            Movie(title: "Movie 3", description: "Some Common description"),
            Movie(title: "Movie 4", description: "Some Common description"),
            Movie(title: "Movie 5", description: "Some Common description"),
            Movie(title: "Movie 6", description: "Some Common description"),
            Movie(title: "Movie 7", description: "Some Common description"),
            Movie(title: "Movie 8", description: "Some Common description"),
            Movie(title: "Movie 9", description: "Some Common description"),
            Movie(title: "Movie 10", description: "Some Common description")
        ]
    }
}
