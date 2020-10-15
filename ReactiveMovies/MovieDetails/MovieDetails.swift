//
//  MovieDetails.swift
//  ReactiveMovies
//
//  Created by Maciej Krolikowski on 19/04/2020.
//  Copyright © 2020 Maciej Krolikowski. All rights reserved.
//

import SwiftUI
import Combine

class PosterPosition: ObservableObject {
    @Published var value: CGRect = .zero
}

class MovieDetailsViewModel: ObservableObject {
    var movie: MovieDTO
    
    var releaseDate: String {
        guard let productionDate = movie.releaseDate else {
            return ""
        }
        let calendar = Calendar.current
        return "(" + String(calendar.component(.year, from: productionDate)) + ")"
    }
    
    var viewFrame: CGRect = .zero
    
    @ObservedObject var headerViewModel: MovieDetailsHeaderViewModel
    @ObservedObject var castViewModel: CastsViewModel
    @ObservedObject var posterResizableImageImageLoader: AsynchronousImageLoader
    
    var initialPosterPosition = CGRect.zero
    
    init(movie: MovieDTO) {
        self.movie = movie
        self.headerViewModel = MovieDetailsHeaderViewModel(movie: movie)
        self.castViewModel = CastsViewModel(movieId: movie.id)
        self.posterResizableImageImageLoader = AsynchronousImageLoader(imagePath: movie.posterPath, size: .medium)
    }
}

struct MovieDetailsPreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) { }
}

struct MovieDetails: View {
    @State var isShowingContent = false
    @State var posterPosition = CGRect.zero
    @State var startPosterAnimation = false
    
    @State var isPosterAnimating = false
    
    @State var posterStartPosition = CGRect.zero
    @State var posterEndPosition = CGRect.zero
    
    @ObservedObject var viewModel: MovieDetailsViewModel
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(movie: MovieDTO) {
        self.viewModel = MovieDetailsViewModel(movie: movie)
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            ScrollView {
                if isShowingContent {
                    MovieDetailsHeader(viewModel: viewModel.headerViewModel) { posterPosition in
//                        viewModel.initialPosterPosition = posterPosition
//                        self.posterPosition = posterPosition
//                        self.startPosterAnimation = false
//                        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: false) { (timer) in
//                            let width = viewModel.viewFrame.width - 30
//                            let height = width * Constants.imageAspectRatio
//                            self.posterPosition =  CGRect(x: viewModel.viewFrame.minX + 15, y: viewModel.viewFrame.minY + 15, width: width, height: height)
//                            self.startPosterAnimation = true
//                        }
//                        withAnimation { () -> Result in
//
//                        }
                        
                        viewModel.initialPosterPosition = posterPosition
                        posterStartPosition = posterPosition
                        let width = viewModel.viewFrame.width - 30
                        let height = width * Constants.imageAspectRatio
                        self.posterEndPosition =  CGRect(x: viewModel.viewFrame.minX + 15, y: viewModel.viewFrame.minY + 15, width: width, height: height)
                        
                        withAnimation(.easeInOut(duration: 1.0)) {
                            isPosterAnimating = true
                        }
                        
                    }
                    CastsView(viewModel: viewModel.castViewModel)
                        .frame(height: 200)
                    Text("Move details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\n")
                    Spacer()
                }
            }
//            MoviePosterImageResizable(imageLoader: viewModel.posterResizableImageImageLoader)
//                .frame(width: posterPosition.width, height: posterPosition.height)
//                .offset(x: posterPosition.origin.x, y: posterPosition.origin.y)
//                .padding(EdgeInsets(top: 0, leading: 0, bottom: posterPosition.origin.y, trailing: posterPosition.origin.x))
//                .clipped()
//                .aspectRatio(contentMode: .fit)
//                .animation(.default)
//                .onTapGesture {
//                    posterPosition = viewModel.initialPosterPosition
//                }
            
            MoviePosterImageResizable2(imageLoader: viewModel.posterResizableImageImageLoader, pct: isPosterAnimating ? 1 : 0, startFrame: posterStartPosition, endFrame: posterEndPosition)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        isPosterAnimating = false
                    }
                }
                
        }
        .background(GeometryReader { geometry in
            assignViewFrame(geometry: geometry)
        })
        .onPreferenceChange(MovieDetailsPreferenceKey.self, perform: {
            viewModel.viewFrame = $0
        })
        .navigationBarTitle(viewModel.movie.title, displayMode: .inline)
        .coordinateSpace(name: "MovieDetails.main")
        .onAppear {
            self.isShowingContent = true
        }
    }
    
    private func assignViewFrame(geometry: GeometryProxy) -> some View {
        viewModel.viewFrame = geometry.frame(in: .named("MovieDetails.main"))
        return Color.white.preference(key: MovieDetailsPreferenceKey.self, value: viewModel.viewFrame)
    }
}
