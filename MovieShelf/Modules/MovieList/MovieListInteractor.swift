//
//  MovieListInteractor.swift
//  MovieShelf
//
//  Created by Thalita Auad on 06/11/25.
//

import Foundation

final class MovieListInteractor: MovieListInteractorInput {
    weak var output: MovieListInteractorOutput?

    private let api: MoviesAPI
    private let favs: FavoritesStoring
    private let initialQuery: String

    init(api: MoviesAPI, favs: FavoritesStoring, initialQuery: String) {
        self.api = api
        self.favs = favs
        self.initialQuery = initialQuery
    }

    func start() {
        api.search(query: initialQuery, page: 1) { [weak self] result in
            guard let self else { return }
            print(result)
            switch result {
            case .success(let movies): self.output?.didLoad(movies: movies)
            case .failure(let e):      self.output?.didFail(e)
            }
        }
    }

    func isFavorite(id: Int) -> Bool { favs.isSaved(id: id) }

    func toggleFavorite(id: Int, completion: @escaping (Bool) -> Void) {
        let minimal = MovieDetails(
            id: id, originalTitle: "", title: "",
            posterPath: nil, backdropPath: nil, overview: nil,
            releaseDate: nil, budget: nil, revenue: nil, voteAverage: 0
        )
        favs.toggle(details: minimal) { isSavedNow in
            completion(isSavedNow)
        }
    }
}
