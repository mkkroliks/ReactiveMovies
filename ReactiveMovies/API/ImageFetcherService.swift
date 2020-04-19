//
//  ImageFetcherService.swift
//  ReactiveMovies
//
//  Created by Maciej Krolikowski on 16/04/2020.
//  Copyright © 2020 Maciej Krolikowski. All rights reserved.
//

import UIKit
import Combine

class ImageFetcherService {
    static let shared = ImageFetcherService()
    
    enum Size: String {
        case small = "https://image.tmdb.org/t/p/w154/"
        case medium = "https://image.tmdb.org/t/p/w500/"
        case cast = "https://image.tmdb.org/t/p/w185/"
        case original = "https://image.tmdb.org/t/p/original/"
        
        func path(path: String) -> URL {
            return URL(string: rawValue)!.appendingPathComponent(path)
        }
    }
    
    func fetch(imagePath: String, size: Size) -> AnyPublisher<UIImage?, Never> {
        URLSession.shared.dataTaskPublisher(for: size.path(path: imagePath))
            .tryMap { (data, _) -> UIImage? in
                return UIImage(data: data)
            }.catch { error in
                return Just(nil)
            }.eraseToAnyPublisher()
    }
}

class ImageLoadersCache {
    static let share = ImageLoadersCache()
    
    private let cache = NSCache<NSString, AsynchronousImageLoader>()
    
    func create(imagePath: String?, size: ImageFetcherService.Size) -> AsynchronousImageLoader {
        let path = NSString(string: "\(imagePath ?? "unknown path")#\(size.rawValue)")
        if let imageLoader = cache.object(forKey: path) {
            return imageLoader
        } else {
            let loader = AsynchronousImageLoader(imagePath: imagePath, size: size)
            cache.setObject(loader, forKey: path)
            return loader
        }
    }
}

class AsynchronousImageLoader: ObservableObject {
    @Published var image: UIImage?
    
    private let imagePath: String?
    private let size: ImageFetcherService.Size
    
    private var cancellable: AnyCancellable?
    
    var objectWillChange: AnyPublisher<UIImage?, Never> = Publishers.Sequence<[UIImage?], Never>(sequence: []).eraseToAnyPublisher()
    
    init(imagePath: String?, size: ImageFetcherService.Size) {
        self.imagePath = imagePath
        self.size = size
        
        objectWillChange = $image.handleEvents(receiveSubscription: { [weak self] _ in
            self?.loadImage()
        }, receiveCancel: { [weak self] in
            self?.cancellable?.cancel()
        }).eraseToAnyPublisher()
    }
    
    private func loadImage() {
        guard let imagePath = imagePath, image == nil else {
            return
        }
        cancellable = ImageFetcherService.shared.fetch(imagePath: imagePath, size: size)
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }
    
    deinit {
        cancellable?.cancel()
    }
}
