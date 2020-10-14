//
//  PopularMovieImageView.swift
//  ReactiveMovies
//
//  Created by Maciej Krolikowski on 12/10/2020.
//  Copyright © 2020 Maciej Krolikowski. All rights reserved.
//

import SwiftUI

struct PopularMovieImageView: View {
    
    @ObservedObject var imageLoader: AsynchronousImageLoader
        
    var body: some View {
        ZStack {
            if imageLoader.image != nil {
                Image(uiImage: imageLoader.image!)
                    .frame(maxHeight: 50)
            } else {
                Rectangle()
                    .frame(maxHeight: 50)
                    .foregroundColor(.orange)
            }
        }
    }
}
