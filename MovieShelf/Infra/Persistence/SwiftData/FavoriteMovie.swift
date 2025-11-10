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

    init(from details: MovieDetails) {
        id = details.id
        originalTitle = details.originalTitle
        title = details.title
        posterPath = details.posterPath
        backdropPath = details.backdropPath
        overview = details.overview
        releaseDate = details.releaseDate
        budget = details.budget
        revenue = details.revenue
        voteAverage = details.voteAverage
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
