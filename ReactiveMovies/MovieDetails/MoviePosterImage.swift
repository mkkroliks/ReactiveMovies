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
    
//    init(imageLoader: AsynchronousImageLoader, onTap: () -> ()) {
//        
//    }
    
    var body: some View {
        HStack {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                EmptyView()
            }
        }
        
    }
}

struct MoviePosterImageResizable2: View {
    @ObservedObject var imageLoader: AsynchronousImageLoader
    
    let pct: Double
    let startFrame: CGRect
    let endFrame: CGRect
    
    init(imageLoader: AsynchronousImageLoader, pct: Double, startFrame: CGRect, endFrame: CGRect) {
        self.imageLoader = imageLoader
        self.pct = pct
        self.startFrame = startFrame
        self.endFrame = endFrame
    }
    
    struct MoviePosterModifier: AnimatableModifier {
        var pct: CGFloat = 0
        var startFrame: CGRect = .zero
        var endFrame: CGRect = .zero
        
//        init(pct: CGFloat = 0, startFrame: CGRect = .zero, endFrame: CGRect = .zero) {
//            self.pct = pct
//            self.startFrame = startFrame
//            self.endFrame = endFrame
//        }
        
        var animatableData: CGFloat {
            get { pct }
            set { pct = newValue }
        }
        
        func body(content: Content) -> some View {
            content
                .frame(width: posterWidth, height: posterHeight)
                .offset(x: posterX, y: posterY)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: posterY, trailing: posterX))
                .clipped()
                .aspectRatio(contentMode: .fit)
                .opacity((pct == 0) ? 0 : 1)
        }
        
        private var posterWidth: CGFloat {
            return startFrame.width + (endFrame.width - startFrame.width) * pct
        }
        
        private var posterHeight: CGFloat {
            return startFrame.height + (endFrame.height - startFrame.height) * pct
        }
        
        private var posterX: CGFloat {
            startFrame.minX + (endFrame.minX - startFrame.minX) * pct
        }
        
        private var posterY: CGFloat {
            startFrame.minY + (endFrame.minY - startFrame.minY) * pct
        }
    }
    
    
    var body: some View {
        HStack {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    
            } else {
                EmptyView()
            }
        }
        .modifier(MoviePosterModifier(pct: CGFloat(pct), startFrame: startFrame, endFrame: endFrame))
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
