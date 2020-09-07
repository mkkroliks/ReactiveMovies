//
//  MoviePosterImage.swift
//  ReactiveMovies
//
//  Created by Maciej Krolikowski on 25/04/2020.
//  Copyright © 2020 Maciej Krolikowski. All rights reserved.
//

import SwiftUI

struct MoviePosterImageResizable: View {
    @ObservedObject var imageLoader: AsynchronousImageLoader
    
    var body: some View {
        Image(uiImage: UIImage(named: "parasite")!)
//        Image(uiImage: imageLoader.image ?? UIImage())
            .resizable()
            .aspectRatio(contentMode: .fill)
//            .resizable()
//            .aspectRatio(contentMode: .fill)
//            .clipped()
//            .cornerRadius(8)
        // Partially working with image
//        Image(uiImage: imageLoader.image ?? UIImage())
    }
}


struct MoviePosterImage: View {
    @ObservedObject var imageLoader: AsynchronousImageLoader
    
    var body: some View {
        ZStack {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 150)
                    .cornerRadius(8)
            } else {
                Rectangle()
                .frame(width: 100, height: 150)
                .cornerRadius(8)
            }
        }
    }
}
