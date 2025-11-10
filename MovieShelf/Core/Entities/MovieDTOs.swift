//
//  MovieDTOs.swift
//  MovieShelf
//
//  Created by Thalita Auad on 09/11/25.
//

import Foundation

struct SearchResponseDTO: Decodable {
    let results: [MovieDTO]
}

struct MovieDTO: Decodable {
    let id: Int
    let originalTitle: String
    let posterPath: String?
    let voteAverage: Double

    enum CodingKeys: String, CodingKey {
        case id
        case originalTitle = "original_title"
        case posterPath    = "poster_path"
        case voteAverage   = "vote_average"
    }
}

struct MovieDetailsDTO: Decodable {
    let id: Int
    let originalTitle: String
    let title: String
    let posterPath: String?
    let backdropPath: String?
    let overview: String?
    let releaseDate: String?
    let budget: Int?
    let revenue: Int?
    let voteAverage: Double

    enum CodingKeys: String, CodingKey {
        case id
        case originalTitle = "original_title"
        case title
        case posterPath    = "poster_path"
        case backdropPath  = "backdrop_path"
        case overview
        case releaseDate   = "release_date"
        case budget
        case revenue
        case voteAverage   = "vote_average"
    }
}
