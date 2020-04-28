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
        case movieCredits(id: String)
        
        var path: String {
            switch self {
            case .popular:
                return "movie/popular"
            case .movieCredits(let id):
                return "movie/\(id)/credits"
            }
        }
    }
    
    func get<DTO: Codable>(
        endpoint: Endpoint,
        params: [String: String]? = nil,
        completion: @escaping (Result<DTO, APIError>) -> Void
    ) {
        let queryURL = baseURL.appendingPathComponent(endpoint.path)
        guard var urlComponents = URLComponents(url: queryURL, resolvingAgainstBaseURL: true) else {
            completion(Result.failure(APIError.urlComponentsCreation))
            return
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "api_key", value: key)
        ]
        if let params = params {
            for (_, value) in params.enumerated() {
                urlComponents.queryItems?.append(URLQueryItem(name: value.key, value: value.value))
            }
        }
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
