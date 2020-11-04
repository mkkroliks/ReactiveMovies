//
//  MoviesSeachTextField.swift
//  ReactiveMovies
//
//  Created by Maciej Krolikowski on 04/11/2020.
//  Copyright © 2020 Maciej Krolikowski. All rights reserved.
//

import SwiftUI
import Combine
import Foundation

struct MoviesSeachTextField: View {

    @Binding var typedText: String

    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: "magnifyingglass.circle")
            TextField("Search for a movie", text: $typedText)
        }
    }
}
