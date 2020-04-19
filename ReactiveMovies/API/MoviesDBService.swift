//
//  MoviesDBService.swift
//  ReactiveMovies
//
//  Created by Maciej Krolikowski on 09/04/2020.
//  Copyright © 2020 Maciej Krolikowski. All rights reserved.
//

import Foundation
import Combine

struct MovieDTO: Codable, Identifiable {

    let posterPath: String?
    let adult: Bool
    let overview: String
    let releaseDateText: String
    let genreIds: [Int]
    let id: Int
    let originalTitle: String
    let originalLanguage: String
    let title: String
    let backdropPath: String?
    let popularity: Float
    let voteCount: Int
    let video: Bool
    let voteAverage: Float
    
    var releaseDate: Date? {
        return MovieDTO.dateFormatter.date(from: releaseDateText)
    }
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyy-MM-dd"
        return formatter
    }()
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case adult, overview
        case releaseDateText = "release_date"
        case genreIds = "genre_ids"
        case id
        case originalTitle = "original_title"
        case originalLanguage = "original_language"
        case title
        case backdropPath = "backdrop_path"
        case popularity
        case voteCount = "vote_count"
        case video
        case voteAverage = "vote_average"
    }
}

struct PaginatedResponse<T: Codable>: Codable {
    let page: Int?
    let totalResults: Int?
    let totalPages: Int?
    let results: [T]
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
    }
}

struct MoviesDBService {
    
    static let shared = MoviesDBService()
    
    func getPopular(page: Int, completion: @escaping (Result<PaginatedResponse<MovieDTO>, APIService.APIError>) -> Void) {
        APIService.shared.get(endpoint: .popular, params: ["page": "\(page)"]) { (result: Result<PaginatedResponse<MovieDTO>, APIService.APIError>) in
            switch result {
            case .success(let response):
                completion(Result.success(response))
            case .failure(let error):
                completion(Result.failure(error))
            }
        }
    }
    
    func getPopular(page: Int) -> AnyPublisher<PaginatedResponse<MovieDTO>, APIService.APIError> {
        let future = Future<PaginatedResponse<MovieDTO>, APIService.APIError> { promise in
            self.getPopular(page: page) { result in
                switch result {
                case .success(let movies):
                    promise(.success(movies))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        return AnyPublisher(future)
    }
}
