//
//  Movie.swift
//  ReactiveMovies
//
//  Created by Maciej Krolikowski on 08/04/2020.
//  Copyright © 2020 Maciej Krolikowski. All rights reserved.
//

import Foundation

struct Movie: Identifiable {
    var id = UUID()
    let title: String
    let description: String
//    let imageUrl: URL
}
