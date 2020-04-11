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
    let id: Int
    let title: String
}

let sampleMovie = MovieDTO(id: 0,
                           title: "Test movie Test movie Test movie Test movie Test movie Test movie Test movie  Test movie Test movie Test movie")

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
    
    func getPopular(completion: @escaping (Result<[MovieDTO], APIService.APIError>) -> Void) {
        APIService.shared.get(endpoint: .popular) { (result: Result<PaginatedResponse<MovieDTO>, APIService.APIError>) in
            switch result {
            case .success(let response):
                completion(Result.success(response.results))
            case .failure(let error):
                completion(Result.failure(error))
            }
        }
    }
    
    func getPopular() -> AnyPublisher<[MovieDTO], APIService.APIError> {
        let future = Future<[MovieDTO], APIService.APIError> { promise in
            self.getPopular { result in
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
