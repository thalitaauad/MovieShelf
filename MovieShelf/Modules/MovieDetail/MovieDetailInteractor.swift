//
//  MovieDetailInteractor.swift
//  MovieShelf
//
//  Created by Thalita Auad on 06/11/25.
//

import Foundation

final class MovieDetailInteractor: MovieDetailInteractorInput {
    weak var output: MovieDetailInteractorOutput?

    private let api: MoviesAPI
    private let favs: FavoritesStoring
    private let movieID: Int
    private var current: MovieDetails?

    init(api: MoviesAPI, favs: FavoritesStoring, movieID: Int) {
        self.api = api
        self.favs = favs
        self.movieID = movieID
    }

    func loadDetails() {
        api.details(id: movieID) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let d):
                self.current = d
                self.output?.didLoad(details: d)
            case .failure(let e):
                self.output?.didFail(e)
            }
        }
    }

    func toggleFavorite() {
        let details: MovieDetails
        if let curr = current {
            details = curr
        } else {
            details = MovieDetails(
                id: movieID, originalTitle: "", title: "",
                posterPath: nil, backdropPath: nil, overview: nil,
                releaseDate: nil, budget: nil, revenue: nil, voteAverage: 0
            )
        }

        favs.toggle(details: details) { [weak self] _ in   
            guard let self else { return }
            let nowSaved = self.favs.isSaved(id: self.movieID)
            self.output?.didToggle(saved: nowSaved)
        }
    }

    func isSaved() -> Bool { favs.isSaved(id: movieID) }
}
