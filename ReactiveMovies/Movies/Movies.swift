//
//  Movies.swift
//  ReactiveMovies
//
//  Created by Maciej Krolikowski on 14/05/2020.
//  Copyright © 2020 Maciej Krolikowski. All rights reserved.
//

import SwiftUI
import Combine

struct WidthKey: PreferenceKey {
    static let defaultValue: CGFloat? = nil
    static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
        value = value ?? nextValue()
    }
}

struct MovieImage: View {
    @ObservedObject var imageLoader: AsynchronousImageLoader
    
    var body: some View {
        GeometryReader { reader in
            ZStack {
                if imageLoader.image != nil {
                    Image(uiImage: imageLoader.image!)
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

extension VerticalAlignment {
    enum RatingAndPoster: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[.top]
        }
    }
    
    static let ratingAndPosterVerticalAlignment = VerticalAlignment(RatingAndPoster.self)
}

extension HorizontalAlignment {
    enum RatingAndPoster: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[.leading]
        }
    }
    
    static let ratingAndPosterHorizontalAlignment = HorizontalAlignment(RatingAndPoster.self)
}

extension Alignment {
    static let ratingAndPosterAlignment = Alignment(horizontal: .ratingAndPosterHorizontalAlignment, vertical: .ratingAndPosterVerticalAlignment)
}

struct MovieView: View {
    
    var movie: MovieDTO
    
    private let imageAspectRatio: CGFloat = 1.5
    
    @State private var height: CGFloat = 170
    
    var body: some View {
        ZStack(alignment: .ratingAndPosterAlignment) {
            VStack(alignment: .leading, spacing: 0) {
                MovieImage(imageLoader: AsynchronousImageLoader(imagePath: self.movie.posterPath, size: .movie))
                    .frame(height: height)
                    .alignmentGuide(.ratingAndPosterVerticalAlignment) { dimension in
                        dimension[.bottom]
                    }
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 1) {
                        Text(self.movie.title)
                            .foregroundColor(.black)
                            .font(.system(size: 10)).bold()
                            .lineLimit(1)
                        Text(self.movie.releaseDate?.toMoviePosterDateString() ?? "")
                            .foregroundColor(.black)
                            .font(.system(size: 10))
                    }
                    .alignmentGuide(.ratingAndPosterHorizontalAlignment) { dimension in
                        dimension[.leading]
                    }
                }
                .padding(EdgeInsets(top: 30, leading: 8, bottom: 10, trailing: 8))
            }
            .background(GeometryReader { reader in
                Color.white.preference(key: WidthKey.self, value: reader.size.width)
            })
            .onPreferenceChange(WidthKey.self, perform: {
                height = imageAspectRatio * ($0 ?? 0)
            })
            .cornerRadius(10)
            .shadow(color: Color.gray.opacity(0.3), radius: 6)
            
            RatingView(percentToShow: self.movie.voteAverage * 10, animate: false)
                .alignmentGuide(.ratingAndPosterHorizontalAlignment) { dimension in
                    dimension[.leading]
                }
                .alignmentGuide(.ratingAndPosterVerticalAlignment) { dimension in
                    dimension[VerticalAlignment.center]
                }
        }
    }
}

struct MovieView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            MovieView(movie: MovieDTOFactory.make()).frame(width: 100, height: 250)
        }
    }
}

final class PopularMoviesSectionViewModel: ObservableObject {
    
    @Published var movies: [MovieDTO] = []
    
    @ObservedObject var typedText: TypedText = TypedText()
    
    private var fetchedData: [MovieDTO] = []
    
    private var subscriptions = Set<AnyCancellable>()
    
    private var currentPage = 1
    
    @Published var searchedMovie: [MovieDTO] = []
    
    var isSearching: Bool {
        return typedText.value.count > 0
    }
    
    init() {
        fetchMovies(page: 1)
        
        typedText.$value
            .filter({ (value) -> Bool in
                if value.isEmpty {
                    self.movies = self.fetchedData
                    return false
                }
                return true
            })
            .handleEvents(receiveOutput: { text in
                print(text)
            })
            .flatMap{ typedText -> AnyPublisher<PaginatedResponse<MovieDTO>, APIService.APIError> in
                return MoviesDBService.shared.searchMovie(text: typedText)
            }
            .replaceError(with: PaginatedResponse<MovieDTO>(page: nil, totalResults: nil, totalPages: nil, results: []))
            .map(\.results)
            .receive(on: DispatchQueue.main)
            .assign(to: \.movies, on: self)
            .store(in: &subscriptions)
    }
    
    func fetchNextPage() {
        fetchMovies(page: currentPage + 1)
    }
    
    private func fetchMovies(page: Int) {
        MoviesDBService.shared
            .getPopular(page: page)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: { response in
                self.movies += response.results
                self.fetchedData += response.results
                self.currentPage = response.page ?? 0
            })
        .store(in: &subscriptions)
    }
}

struct Movies: View {
    
    @ObservedObject var viewModel = PopularMoviesSectionViewModel()
    
    var numberOfElementsInRow = 3
    
    let layout = [
        GridItem(.adaptive(minimum: 105), spacing: 15)
    ]
    
    var elementCount = 0
    var currentRow = 0
    
    var body: some View {
        NavigationView {
            ScrollView {
                SeachTextField(typedText: viewModel.$typedText.value)
                LazyVGrid(columns: layout, spacing: 20) {
                    ForEach(viewModel.movies) { movie in
                        NavigationLink(destination: MovieDetails(movie: movie)) {
                            MovieView(movie: movie)
                        }.buttonStyle(PlainButtonStyle())
                    }
                    Rectangle()
                        .foregroundColor(.clear)
                        .onAppear {
                            if !self.viewModel.movies.isEmpty, !self.viewModel.isSearching {
                                self.viewModel.fetchNextPage()
                            }
                        }
                }
                .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
            }
            .navigationBarTitle(Text("Movies"), displayMode: .large)
        }
    }
    private func getView(for row: Int, column: Int) -> some View {
        let index = row * self.numberOfElementsInRow + column
        guard index < self.viewModel.movies.count else {
            return AnyView(EmptyView())
        }
        let movie = self.viewModel.movies[row * self.numberOfElementsInRow + column]
        return AnyView(
            NavigationLink(destination: MovieDetails(movie: movie)) {
                MovieView(movie: movie)
            }.buttonStyle(PlainButtonStyle())
        )
    }
}

struct MoviesView_Previews: PreviewProvider {
    static let viewModel: PopularMoviesSectionViewModel = {
        let viewModel = PopularMoviesSectionViewModel()
        viewModel.movies = []
        return viewModel
    }()
    
    static var previews: some View {
        Movies(viewModel: viewModel)
    }
}

struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content

    var body: some View {
        VStack {
            ForEach(0 ..< rows, id: \.self) { row in
                HStack {
                    ForEach(0 ..< self.columns, id: \.self) { column in
                        self.content(row, column)
                    }
                }
            }
        }
    }

    init(rows: Int, columns: Int, @ViewBuilder content: @escaping (Int, Int) -> Content) {
        self.rows = rows
        self.columns = columns
        self.content = content
    }
}
