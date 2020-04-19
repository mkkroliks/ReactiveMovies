//
//  MovieDetailsBlurredImage.swift
//  ReactiveMovies
//
//  Created by Maciej Krolikowski on 19/04/2020.
//  Copyright © 2020 Maciej Krolikowski. All rights reserved.
//

import SwiftUI

struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemMaterial
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

struct MovieDetailsBlurredImage: View {
    
    @ObservedObject var imageLoader: AsynchronousImageLoader
    
    var body: some View {
        ZStack {
            if imageLoader.image != nil {
                ZStack {
                    Image(uiImage: imageLoader.image!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                    Blur(style: .dark)
                }
                .frame(height: 200)
                .clipped()
            } else {
                Rectangle()
                    .frame(maxHeight: 200)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct MovieDetailsHeader: View {
    
    @ObservedObject var imageLoader: AsynchronousImageLoader
        
    var releaseDate: String {
        guard let productionDate = movie.releaseDate else {
            return ""
        }
        let calendar = Calendar.current
        return "(" + String(calendar.component(.year, from: productionDate)) + ")"
    }
    
    var movie: MovieDTO
    
    var body: some View {
        ZStack {
            MovieDetailsBlurredImage(imageLoader: imageLoader)
            HStack(alignment: .top) {
                MoviePosterImage(imageLoader: imageLoader)
                VStack(alignment: .leading) {
                    HStack {
                        Text(movie.title)
                            .foregroundColor(.white)
                            .font(Font.headline.bold())
                        Text(releaseDate)
                            .foregroundColor(.white)
                            .font(Font.headline.weight(.light))
                    }
                    .padding(.bottom, 15)
                    Text("Overview")
                        .foregroundColor(.white)
                        .font(Font.subheadline.bold())
                        .padding(.bottom, 5)
                    Text(movie.overview)
                        .foregroundColor(.white)
                        .font(Font.caption)
                }
                Spacer()
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
        }
    }
}

struct MoviePosterImage: View {
    @ObservedObject var imageLoader: AsynchronousImageLoader
    
    var body: some View {
        ZStack {
            if imageLoader.image != nil {
                Image(uiImage: imageLoader.image!)
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

#if DEBUG
private class ImageLoaderMock: AsynchronousImageLoader {
    init(image: UIImage) {
        super.init(imagePath: nil, size: .small)
        self.image = image
    }
}

struct MovieDetailsBlurredImage_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailsBlurredImage(imageLoader: ImageLoaderMock(image: UIImage(named: "parasite")!))
    }
}

struct MovieDetailsHeader_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailsHeader(imageLoader: ImageLoaderMock(image: UIImage(named: "parasite")!),
                           movie: MovieDTOFactory.make(overview: "All unemployed, Ki-taek's family takes peculiar interest in the wealthy and glamorous Parks for their livelihood until they get entangled in an unexpected incident.", title: "Parasite"))
    }
}

struct MoviePosterImage_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.gray)
            MoviePosterImage(imageLoader: ImageLoaderMock(image: UIImage(named: "parasite")!))
        }
    }
}

struct MovieDTOFactory {
    static func make(posterPath: String? = nil,
              adult: Bool = false,
              overview: String = "Overview",
              releaseDateText: String = "2019-04-02",
              genreIds: [Int] = [1],
              id: Int = 123,
              originalTitle: String = "Original Title",
              originalLanguage: String =  "Original Language",
              title: String = "Title",
              backdropPath: String = "BackdropPath",
              popularity: Float = 0,
              voteCount: Int = 0,
              video: Bool = false,
              voteAverage: Float = 0) -> MovieDTO {
        return MovieDTO(posterPath: posterPath,
                        adult: adult,
                        overview: overview,
                        releaseDateText: releaseDateText,
                        genreIds: genreIds,
                        id: id,
                        originalTitle: originalTitle,
                        originalLanguage: originalLanguage,
                        title: title,
                        backdropPath: backdropPath,
                        popularity: popularity,
                        voteCount: voteCount,
                        video: video,
                        voteAverage: voteAverage)
    }
}
#endif
