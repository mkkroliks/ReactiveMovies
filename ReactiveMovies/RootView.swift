//
//  TabbarView.swift
//  ReactiveMovies
//
//  Created by Maciej Krolikowski on 12/11/2020.
//  Copyright © 2020 Maciej Krolikowski. All rights reserved.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            MoviesView()
                .tabItem {
                    Image(systemName: "film")
                    Text("Movies")
                }.tag(0)
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
