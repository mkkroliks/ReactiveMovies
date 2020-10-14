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
    @Published var typedText: String = ""
    var movie: MovieDTO
    
    var releaseDate: String {
        guard let productionDate = movie.releaseDate else {
            return ""
        }
        let calendar = Calendar.current
        return "(" + String(calendar.component(.year, from: productionDate)) + ")"
    }
    
    @ObservedObject var headerViewModel: MovieDetailsHeaderViewModel
    @ObservedObject var castViewModel: CastsViewModel
    
    @ObservedObject var posterResizableImageImageLoader: AsynchronousImageLoader
    
    init(movie: MovieDTO) {
        self.movie = movie
        self.headerViewModel = MovieDetailsHeaderViewModel(movie: movie)
        self.castViewModel = CastsViewModel(movieId: movie.id)
        self.posterResizableImageImageLoader = AsynchronousImageLoader(imagePath: movie.posterPath, size: .medium)
    }
}

struct MovieDetails: View {
    @State var isShowingContent = false
    
    @State var posterPosition = CGRect.zero
    
    @State var startPosterAnimation = false
    
    @ObservedObject var viewModel: MovieDetailsViewModel
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(movie: MovieDTO) {
        self.viewModel = MovieDetailsViewModel(movie: movie)
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            ScrollView {
                if isShowingContent {
                    TextField("Tytuł", text: $viewModel.typedText)
                    
                    MovieDetailsHeader(viewModel: viewModel.headerViewModel) { posterPosition in
                        self.posterPosition = posterPosition
                        self.startPosterAnimation = false
                        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: false) { (timer) in
                            self.posterPosition = CGRect(x: 15, y: 15, width: UIScreen.main.bounds.width - 30, height: 500)
                            self.startPosterAnimation = true
                        }
                    }
                    CastsView(viewModel: viewModel.castViewModel)
                        .frame(height: 200)
                    Text("Move details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\nMove details\n")
                    Spacer()
                }
            }
            MoviePosterImageResizable(imageLoader: viewModel.posterResizableImageImageLoader)
                .frame(width: posterPosition.width, height: posterPosition.height)
                .offset(x: posterPosition.origin.x, y: posterPosition.origin.y)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: posterPosition.origin.y, trailing: posterPosition.origin.x))
                .clipped()
                .aspectRatio(contentMode: .fit)
                .animation(startPosterAnimation ? .default : nil)
        }
        .navigationBarTitle(viewModel.movie.title, displayMode: .inline)
        .coordinateSpace(name: "MovieDetails.main")
        .onAppear {
            self.isShowingContent = true
        }
    }
    
}
