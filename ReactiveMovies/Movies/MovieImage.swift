//
//  MovieImage.swift
//  ReactiveMovies
//
//  Created by Maciej Krolikowski on 12/10/2020.
//  Copyright © 2020 Maciej Krolikowski. All rights reserved.
//

import SwiftUI
import Combine

struct MovieImage: View {
    @ObservedObject var imageLoader: AsynchronousImageLoader
    
    var body: some View {
        GeometryReader { reader in
            ZStack {
                if let image = imageLoader.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: reader.size.width, height: reader.size.height)
                } else {
                    Rectangle().foregroundColor(.white)
                }
            }
            .clipped()
        }
    }
}
