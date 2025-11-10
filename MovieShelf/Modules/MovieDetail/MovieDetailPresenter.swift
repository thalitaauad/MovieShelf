//
//  MovieDetailPresenter.swift
//  MovieShelf
//
//  Created by Thalita Auad on 06/11/25.
//

import Foundation

final class MovieDetailPresenter: MovieDetailViewOutput, MovieDetailInteractorOutput {
    private weak var view: MovieDetailViewInput?
    private let interactor: MovieDetailInteractorInput
    private let router: MovieDetailRouterProtocol

    init(view: MovieDetailViewInput,
         interactor: MovieDetailInteractorInput,
         router: MovieDetailRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    // MARK: ViewOutput
    func viewDidLoad() {
        view?.showLoading(true)
        view?.setSaved(interactor.isSaved())
        interactor.loadDetails()
    }

    func didTapSave() {
        interactor.toggleFavorite()
    }

    // MARK: InteractorOutput
    func didLoad(details: MovieDetails) {
        view?.showLoading(false)
        view?.show(details: details)
    }

    func didFail(_ error: Error) {
        view?.showLoading(false)
        view?.showError("Couldn’t load details.")
    }

    func didToggle(saved: Bool) {
        view?.setSaved(saved)
        view?.askNavigateToFavorites(saved: saved) { [weak self] in
                self?.router.routeToFavorites()
            }
    }
}
