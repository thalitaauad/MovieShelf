//
//  Movie.swift
//  MovieShelf
//
//  Created by Thalita Auad on 06/11/25.
//

import Foundation

public struct Movie: Hashable {
    public let id: Int
    public let originalTitle: String
    public let posterPath: String?
    public let voteAverage: Double
    public init(id: Int, originalTitle: String, posterPath: String?, voteAverage: Double) {
        self.id = id
        self.originalTitle = originalTitle
        self.posterPath = posterPath
        self.voteAverage = voteAverage
    }
}

public struct MovieDetails: Hashable {
    public let id: Int
    public let originalTitle: String
    public let title: String
    public let posterPath: String?
    public let backdropPath: String?
    public let overview: String?
    public let releaseDate: String?
    public let budget: Int?
    public let revenue: Int?
    public let voteAverage: Double
    public init(id: Int, originalTitle: String, title: String,
                posterPath: String?, backdropPath: String?, overview: String?,
                releaseDate: String?, budget: Int?, revenue: Int?, voteAverage: Double) {
        self.id = id
        self.originalTitle = originalTitle
        self.title = title
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.overview = overview
        self.releaseDate = releaseDate
        self.budget = budget
        self.revenue = revenue
        self.voteAverage = voteAverage
    }
}
