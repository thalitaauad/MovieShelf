//
//  ImageLoader.swift
//  MovieShelf
//
//  Created by Thalita Auad on 06/11/25.
//

import UIKit

final class ImageLoader: ImageLoading {
    static let shared = ImageLoader()
    private let cache = NSCache<NSURL, UIImage>()
    private init() {}

    func load(url: URL, completion: @escaping (UIImage?) -> Void) {
        if let img = cache.object(forKey: url as NSURL) { completion(img); return }
        DispatchQueue.global(qos: .userInitiated).async {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                let img = data.flatMap(UIImage.init)
                if let img { self.cache.setObject(img, forKey: url as NSURL) }
                DispatchQueue.main.async { completion(img) }
            }.resume()
        }
    }
}
