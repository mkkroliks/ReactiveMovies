//
//  APIService.swift
//  ReactiveMovies
//
//  Created by Maciej Krolikowski on 09/04/2020.
//  Copyright © 2020 Maciej Krolikowski. All rights reserved.
//

import Foundation
import Combine

struct APIService {
    
    enum APIError: Error {
        case urlComponentsCreation
        case urlComponentURLCreation
        case emptyResponse
        case response(error: Error)
        case jsonDecoding(error: Error)
    }
    
    enum Method {
        case get
    }
    
    static let shared = APIService()
    let baseURL = URL(string: "https://api.themoviedb.org/3")!
    let key = "ed83110e61acf22eb89b8cf230506de8"
    let decoder = JSONDecoder()
    
    enum Endpoint {
        case popular
        
        var path: String {
            switch self {
            case .popular:
                return "movie/popular"
            }
        }
    }
    
    func get<DTO: Codable>(endpoint: Endpoint, completion: @escaping (Result<DTO, APIError>) -> Void) {
        let queryURL = baseURL.appendingPathComponent(endpoint.path)
        guard var urlComponents = URLComponents(url: queryURL, resolvingAgainstBaseURL: true) else {
            completion(Result.failure(APIError.urlComponentsCreation))
            return
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "api_key", value: key)
        ]
        guard let url = urlComponents.url else {
            completion(Result.failure(APIError.urlComponentURLCreation))
            return
        }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.emptyResponse))
                }
                return
            }
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.response(error: error)))
                }
                return
            }
            do {
                let dto = try self.decoder.decode(DTO.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(dto))
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(.failure(.jsonDecoding(error: error)))
                }
            }
        }
        task.resume()
    }
}

extension Publishers {
    
    class APIServiceSubscription<S: Subscriber, Model: Codable>: Subscription where S.Input == Model, S.Failure == APIService.APIError {
        
        private var subscriber: S?
        private let endpoint: APIService.Endpoint
        private let apiService = APIService.shared
        
        init(endpoint: APIService.Endpoint, subscriber: S) {
            self.endpoint = endpoint
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
