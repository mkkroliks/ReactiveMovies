//
//  APIService.swift
//  ReactiveMovies
//
//  Created by Maciej Krolikowski on 09/04/2020.
//  Copyright © 2020 Maciej Krolikowski. All rights reserved.
//

import Foundation
import Combine

struct Videos: Codable {
    let id: Int
    let results: [Video]
    
    var trailer: Video? { results.first { $0.type == .trailer }}
}

struct Video: Codable {
    enum `Type`: String, Codable {
        case trailer = "Trailer"
        case unknown
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let value = try container.decode(String.self)
            self = Self(rawValue: value) ?? .unknown
        }
    }
    let id, key: String
    let name, site: String
    let size: Int
    let type: Type
}

struct APIService {
    
    enum APIError: Error, LocalizedError {
        case urlComponentsCreation
        case urlComponentURLCreation
        case emptyResponse
        case response(error: Error)
        case jsonDecoding(error: Error)
        case unknown
        case error(reason: String)
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
        case movieVideos(id: String)
        case searchMovie
        case topRated
        case nowPlaying
        case upcoming
        
        var path: String {
            switch self {
            case .popular:
                return "movie/popular"
            case .topRated:
                return "movie/top_rated"
            case .movieCredits(let id):
                return "movie/\(id)/credits"
            case .movieVideos(let id):
                return "movie/\(id)/videos"
            case .searchMovie:
                return "/search/movie"
            case .nowPlaying:
                return "/movie/now_playing"
            case .upcoming:
                return "/movie/upcoming"
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
    
    private func createURLRequest(endpoint: Endpoint, params: [String: String]? = nil) throws -> URLRequest {
        let queryURL = baseURL.appendingPathComponent(endpoint.path)
        guard var urlComponents = URLComponents(url: queryURL, resolvingAgainstBaseURL: true) else {
            throw APIError.urlComponentsCreation
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
            throw APIError.urlComponentURLCreation
        }

        return URLRequest(url: url)
    }
    
    func get<DTO: Codable>(endpoint: Endpoint, params: [String: String]? = nil) -> AnyPublisher<DTO, APIError> {
        do {
            let urlRequest = try createURLRequest(endpoint: endpoint, params: params)
            return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    throw APIError.unknown
                }
                do {
                    let dto = try self.decoder.decode(DTO.self, from: data)
                    return dto
                } catch let error {
                    throw APIError.jsonDecoding(error: error)
                }
            }
            .mapError { error in
                if let error = error as? APIError {
                    return error
                } else {
                    return APIError.error(reason: error.localizedDescription)
                }
            }
            .eraseToAnyPublisher()
        } catch let error {
            if let error = error as? APIError {
                return Fail(error: error).eraseToAnyPublisher()
            } else {
                return Fail(error: APIError.error(reason: error.localizedDescription)).eraseToAnyPublisher()
            }
        }
    }
}
