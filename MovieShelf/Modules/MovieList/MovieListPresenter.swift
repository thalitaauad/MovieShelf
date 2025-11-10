//
//  MovieListPresenter.swift
//  MovieShelf
//
//  Created by Thalita Auad on 06/11/25.
//

import Foundation

struct MovieCellVM: Hashable {
    let id: Int
    let title: String
    let rating: String
    let posterURL: URL?
    var isFavorite: Bool
}

final class MovieListPresenter: MovieListViewOutput, MovieListInteractorOutput {
    private weak var view: MovieListViewInput?
    private let interactor: MovieListInteractorInput
    private let router: MovieListRouterProtocol
    private let imageBase = "https://image.tmdb.org/t/p/w500"

    init(view: MovieListViewInput, interactor: MovieListInteractorInput, router: MovieListRouterProtocol) {
        self.view = view; self.interactor = interactor; self.router = router
    }

    func viewDidLoad() {
        view?.showLoading(true)
        interactor.start()
    }

    func didSelect(id: Int) { router.routeToDetails(movieID: id) }

    func didLoad(movies: [Movie]) {
        view?.showLoading(false)
        let vms = movies.map {
            MovieCellVM(
                id: $0.id,
                title: $0.originalTitle,
                rating: String(format: "%.1f ★", $0.voteAverage),
                posterURL: $0.posterPath.flatMap { URL(string: imageBase + $0)},
                isFavorite: interactor.isFavorite(id: $0.id)
            )
        }
        view?.show(items: vms)
    }

    func didFail(_ error: Error) {
        view?.showLoading(false); view?.showError("Couldn’t load. Try again.")
    }
    
    func didToggleFavorite(id: Int) {
        interactor.toggleFavorite(id: id) { [weak self] _saved in //
            guard let self else { return }
            self.interactor.start()
        }
    }
}
