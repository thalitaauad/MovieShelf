//
//  MoviesAPIProtocol.swift
//  MovieShelf
//
//  Created by Thalita Auad on 06/11/25.
//

import Foundation

public protocol MoviesAPI {
    func search(query: String, page: Int, completion: @escaping (Result<[Movie], Error>) -> Void)
    func details(id: Int, completion: @escaping (Result<MovieDetails, Error>) -> Void)
}
