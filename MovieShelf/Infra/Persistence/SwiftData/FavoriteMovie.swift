//
//  FavoriteMovie.swift
//  MovieShelf
//
//  Created by Thalita Auad on 06/11/25.
//

import Foundation
import SwiftData

@Model
final class FavoriteMovie {
    @Attribute(.unique) var id: Int
    var originalTitle: String
    var title: String
    var posterPath: String?
    var backdropPath: String?
    var overview: String?
    var releaseDate: String?
    var budget: Int?
    var revenue: Int?
    var voteAverage: Double
    var createdAt: Date = Date()

    init(from d: MovieDetails) {
        id = d.id
        originalTitle = d.originalTitle
        title = d.title
        posterPath = d.posterPath
        backdropPath = d.backdropPath
        overview = d.overview
        releaseDate = d.releaseDate
        budget = d.budget
        revenue = d.revenue
        voteAverage = d.voteAverage
    }

    var asDomain: MovieDetails {
        .init(id: id,
              originalTitle: originalTitle,
              title: title,
              posterPath: posterPath,
              backdropPath: backdropPath,
              overview: overview,
              releaseDate: releaseDate,
              budget: budget,
              revenue: revenue,
              voteAverage: voteAverage)
    }
}
