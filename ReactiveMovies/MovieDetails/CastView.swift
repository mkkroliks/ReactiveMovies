//
//  CastView.swift
//  ReactiveMovies
//
//  Created by Maciej Krolikowski on 26/04/2020.
//  Copyright © 2020 Maciej Krolikowski. All rights reserved.
//

import SwiftUI
import Combine

class CastsViewModel: ObservableObject {
    @Published var castViewModel: [CastViewModel] = []
    
    private var subscriptions = Set<AnyCancellable>()
    
    private let movieId: Int
    
    init(movieId: Int) {
        self.movieId = movieId
    }
    
    func fetchMovieCredits() {
        MoviesDBService.shared.getMovieCredits(id: String(movieId))
            .receive(on: DispatchQueue.main)
            .replaceError(with: MovieCredits(id: 0, cast: [], crew: []))
            .map { movieCredits in movieCredits.cast.map { CastViewModel(cast: $0)}  }
            .assign(to: \.castViewModel, on: self)
            .store(in: &subscriptions)
    }
}

struct CastImage: View {
    @ObservedObject var imageLoader: AsynchronousImageLoader
    
    var body: some View {
        ZStack {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                ZStack(alignment: .center) {
                    Image(systemName: "person.fill")
                        .font(.system(size: 60))
                        .foreground(Color.gray)
                }
            }
        }.clipped()
    }
}

struct CastsView: View {
    
    let elementsOnScreen = 4
    
    let spacing: CGFloat = 5
    
    let padding = EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
    
    @ObservedObject var viewModel: CastsViewModel
    
    var body: some View {
        GeometryReader { reader in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .center, spacing: self.spacing) {
                    ForEach(self.viewModel.castViewModel) { castViewModel in
                        return CastView(viewModel: castViewModel)
                            .frame(width: self.getProperElementFrame(reader: reader).size.width,
                                   height: self.getProperElementFrame(reader: reader).size.height)
                    }
                }
                .padding(self.padding)
            }
            .id(UUID().uuidString)
        }
    }
    
    private func getProperElementFrame(reader: GeometryProxy) -> CGRect {
        let elementWidth  = (reader.size.width - (CGFloat(elementsOnScreen - 1) * spacing)) / (CGFloat(elementsOnScreen) - 0.5)
        let elementHeight = reader.size.height - padding.top - padding.bottom
//        print("elementWidth \(elementWidth), height \(elementHeight)")
        return CGRect(x: 0, y: 0, width: elementWidth, height: elementHeight)
    }
}

//struct CastsView_Previews: PreviewProvider {
//    static var previews: some View {
//        let viewModel = CastsViewModel(movieId: 419704)
//        viewModel.cast = [
//            CastFactory.make(character: "Kim Ki-taek", name: "Song Kang-ho", profilePath: nil),
//            CastFactory.make(character: "Park Dong-ik", name: "Lee Sun-kyun", profilePath: nil),
//            CastFactory.make(character: "Yeon-kyo", name: "Cho Yeo-jeong", profilePath: nil),
//            CastFactory.make(character: "Ki-woo", name: "Choi Woo-shik", profilePath: nil),
//            CastFactory.make(character: "Park So-dam", name: "Ki-jung", profilePath: nil),
//            CastFactory.make(character: "Lee Jung-eun", name: "Moon-gwang", profilePath: nil)
//        ]
//        return CastsView(viewModel: viewModel)
//    }
//}

class CastViewModel: ObservableObject, Identifiable {
    let cast: Cast
    @ObservedObject var imageLoader: AsynchronousImageLoader
    
    var id: Int { cast.id }
    
    init(cast: Cast) {
        self.cast = cast
        self.imageLoader = ImageLoadersCache.share.create(imagePath: cast.profilePath, size: .medium)
    }
}

struct CastView: View {
    
    var viewModel: CastViewModel
    
    init(viewModel: CastViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        GeometryReader { reader in
            VStack(alignment: .leading) {
                CastImage(imageLoader: viewModel.imageLoader)
                    .frame(width: reader.size.width, height: 3/4 * reader.size.height)
                    .clipped()
                VStack(alignment: .leading, spacing: 1) {
                    Text(viewModel.cast.name)
                        .foregroundColor(.black)
                        .font(.system(size: 10)).bold()
                    Text(viewModel.cast.character)
                        .foregroundColor(.black)
                        .font(.system(size: 10))
                }
                .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
                .frame(height: 1/4 * reader.size.height)
            }
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.gray.opacity(0.3), radius: 6)
        }
    }
}

//struct CastView_Previews: PreviewProvider {
//    static var previews: some View {
//        VStack {
//            CastView(cast: CastFactory.make(character: "Kim Ki-taek", name: "Song Kang-ho", profilePath: nil))
//        }
//    }
//}
