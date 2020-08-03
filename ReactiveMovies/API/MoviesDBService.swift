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
    
    func getMovieCredits(id: String, completion: @escaping (Result<MovieCredits, APIService.APIError>) -> Void) {
        APIService.shared.get(endpoint: .movieCredits(id: id)) { (result: Result<MovieCredits, APIService.APIError>) in
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
    
    func getMovieCredits(id: String) -> AnyPublisher<MovieCredits, APIService.APIError> {
        return APIService.shared.get(endpoint: .movieCredits(id: id))
    }
    
    func getMovieVideos(id: String) -> AnyPublisher<Videos, APIService.APIError> {
        return APIService.shared.get(endpoint: .movieVideos(id: id))
    }
    
    func searchMovie(text: String) -> AnyPublisher<PaginatedResponse<MovieDTO>, APIService.APIError> {
        return APIService.shared.get(endpoint: .searchMovie, params: ["query": text])
    }
}
struct MovieCredits: Codable {
    let id: Int
    let cast: [Cast]
    let crew: [Crew]
}

struct Cast: Codable, Identifiable, Hashable {
    let castID: Int
    let character: String
    let creditID: String
    let gender: Int
    let id: Int
    let name: String
    let order: Int
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case castID = "cast_id"
        case character
        case creditID = "credit_id"
        case gender, id, name, order
        case profilePath = "profile_path"
    }
}

struct Crew: Codable {
    let creditID: String
    let department: String
    let gender: Int
    let id: Int
    let job: String
    let name: String
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case creditID = "credit_id"
        case department, gender, id, job, name
        case profilePath = "profile_path"
    }
}

struct CastFactory {
    static func make(castID: Int = 0,
                     character: String = "",
                     creditID: String = "",
                     gender: Int = 0,
                     id: Int = 0,
                     name: String = "",
                     order: Int = 0,
                     profilePath: String?) -> Cast {
        Cast(castID: castID,
             character: character,
             creditID: creditID,
             gender: gender,
             id: id,
             name: name,
             order: order,
             profilePath: profilePath)
    }
}

struct CrewFactory {
    static func make(creditID: String,
                     department: String,
                     gender: Int,
                     id: Int,
                     job: String,
                     name: String,
                     profilePath: String?) -> Crew {
        Crew(creditID: creditID,
             department: department,
             gender: gender,
             id: id,
             job: job,
             name: name,
             profilePath: profilePath)
    }
}
