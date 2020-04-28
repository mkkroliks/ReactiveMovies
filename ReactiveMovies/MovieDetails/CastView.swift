//
//  CastView.swift
//  ReactiveMovies
//
//  Created by Maciej Krolikowski on 26/04/2020.
//  Copyright © 2020 Maciej Krolikowski. All rights reserved.
//

import SwiftUI
import Combine

class CastViewModel: ObservableObject {
    @Published var cast: [Cast] = []
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(movieId: Int) {
        MoviesDBService.shared.getMovieCredits(id: String(movieId))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (completion) in
                print("")
            }) { [weak self] credits in
                self?.cast = credits.cast
            }.store(in: &subscriptions)
    }
}

struct CastImage: View {
    @ObservedObject var imageLoader: AsynchronousImageLoader
    
    var body: some View {
        ZStack {
            if imageLoader.image != nil {
                Image(uiImage: imageLoader.image!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Rectangle()
            }
        }.clipped()
    }
}

struct CastsView: View {
    
    @ObservedObject var viewModel: CastViewModel
    
    var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center) {
                    ForEach(self.viewModel.cast, id: \.self) { cast in
                        CastView(cast: cast)
//                            .frame(width: 100, height: 180)
                    }
                }
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
            }
            .id(UUID().uuidString)
    }
}

struct CastsView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = CastViewModel(movieId: 419704)
        viewModel.cast = [
            CastFactory.make(character: "Kim Ki-taek", name: "Song Kang-ho", profilePath: nil),
            CastFactory.make(character: "Park Dong-ik", name: "Lee Sun-kyun", profilePath: nil),
            CastFactory.make(character: "Yeon-kyo", name: "Cho Yeo-jeong", profilePath: nil),
            CastFactory.make(character: "Ki-woo", name: "Choi Woo-shik", profilePath: nil),
            CastFactory.make(character: "Park So-dam", name: "Ki-jung", profilePath: nil),
            CastFactory.make(character: "Lee Jung-eun", name: "Moon-gwang", profilePath: nil)
        ]
        return CastsView(viewModel: viewModel)
    }
}

struct CastView: View {
    
    var cast: Cast
    
    var body: some View {
        VStack(alignment: .leading) {
            CastImage(imageLoader: AsynchronousImageLoader(imagePath: cast.profilePath, size: .medium))
                .frame(height: 130)
                .clipped()
            VStack(alignment: .leading, spacing: 1) {
                Text(cast.name)
                    .foregroundColor(.black)
                    .font(.system(size: 10)).bold()
                Text(cast.character)
                    .foregroundColor(.black)
                    .font(.system(size: 10))
            }
            .padding(EdgeInsets(top: 0, leading: 6, bottom: 6, trailing: 6))
            .frame(height: 50)
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.gray.opacity(0.3), radius: 6)
    }
}

struct CastView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CastView(cast: CastFactory.make(character: "Kim Ki-taek", name: "Song Kang-ho", profilePath: nil))
        }
        .frame(width: 120, height: 200)
    }
}
