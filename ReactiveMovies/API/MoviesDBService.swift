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
    
    func reactive() {
    }
}

extension Publishers {
    
    class MoviesDBService<S: Subscriber, Model: Codable>: Subscription where S.Input == Model, S.Failure == APIService.APIError {
        
        private var subscriber: S?
        private let completion: (Result<[MovieDTO], APIService.APIError>) -> Void
        private let apiService = APIService.shared
        
        init(completion: @escaping (Result<[MovieDTO], APIService.APIError>) -> Void, subscriber: S) {
            self.completion = completion
            self.subscriber = subscriber
        }
        
        func request(_ demand: Subscribers.Demand) {
            
        }
        
        func cancel() {
            subscriber = nil
        }
        
        private func send() {
//            guard let subscriber = subscriber else { return }
//            apiService.get(endpoint: endpoint) { (result: Result<Model, APIService.APIError>) in
//                switch result {
//                case .success(let response):
//                    _ = subscriber.receive(response)
//                case .failure(let error):
//                    _ = subscriber.receive(completion: Subscribers.Completion.failure(error))
//                }
//            }
//            completion { result in
//                switch result {
//                case .success(let movies):
//                    print(movies)
//                case .failure(let error):
//                    print(error)
//                }
//            }
        }
    }
    
//    struct ResponsePublisher<Model: Codable>: Publisher {
//        typealias Output = Model
//        typealias Failure = APIService.APIError
//
//        private let endpoint: APIService.Endpoint
//
//        init(endpoint: APIService.Endpoint) {
//            self.endpoint = endpoint
//        }
//
//        func receive<S: Subscriber>(subscriber: S) where
//            ResponsePublisher.Output == S.Failure, ResponsePublisher.Output == S.Input {
//                let subscription = APIServiceSubscription(endpoint: endpoint, subscriber: subscriber) as
//                subscriber.receive(subscription: subscription)
//        }
//    }
}

//extension URLSession {
//    func dataResponse(for function: ())
//}

//struct CombineMovieDBService {
//    static let shared = CombineMovieDBService()
//    
//    func getPopular() -> AnyPublisher<[MovieDTO], APIService.APIError> {
//        AnyPublisher.
//    }
//}

//struct CombineMovieDBServiceSubscription<S: >
