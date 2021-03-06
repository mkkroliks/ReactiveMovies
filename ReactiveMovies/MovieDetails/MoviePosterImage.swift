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
    
    let pct: Double
    let frame: CGRect
    
    init(imageLoader: AsynchronousImageLoader, pct: Double, frame: CGRect) {
        self.imageLoader = imageLoader
        self.pct = pct
        self.frame = frame
    }
    
    struct MoviePosterModifier: AnimatableModifier {
        var pct: CGFloat
        var frame: CGRect

        var animatableData: CGFloat {
            get { pct }
            set { pct = newValue }
        }
        
        func body(content: Content) -> some View {
            content
                .frame(width: frame.width, height: frame.height)
                .offset(x: frame.minX, y: frame.minY)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: frame.minY, trailing: frame.minX))
                .clipped()
                .aspectRatio(contentMode: .fit)
                .opacity((pct == 0) ? 0 : 1)
        }
    }
    
    var body: some View {
        Group {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    
            } else {
                EmptyView()
            }
        }
        .modifier(MoviePosterModifier(pct: CGFloat(pct), frame: frame))
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
