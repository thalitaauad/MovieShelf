//
//  ImageLoading.swift
//  MovieShelf
//
//  Created by Thalita Auad on 07/11/25.
//

import UIKit

public protocol ImageLoading {
    func load(url: URL, completion: @escaping (UIImage?) -> Void)
}
