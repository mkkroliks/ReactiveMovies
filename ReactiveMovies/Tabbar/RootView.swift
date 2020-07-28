//
//  RootView.swift
//  ReactiveMovies
//
//  Created by Maciej Krolikowski on 14/05/2020.
//  Copyright © 2020 Maciej Krolikowski. All rights reserved.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            Movies().tabItem { Text("Movies") }.tag(1)
            PopularMovies().tabItem { Text("Popular movies") }.tag(2)
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
