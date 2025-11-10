//
//  FavoritesListPresenter.swift
//  MovieShelf
//
//  Created by Thalita Auad on 07/11/25.
//

import Foundation

struct FavoriteCellVM: Hashable {
    let id: Int
    let title: String
    let rating: String
}

final class FavoritesListPresenter: FavoritesListViewOutput, FavoritesListInteractorOutput {
    private weak var view: FavoritesListViewInput?
    private let interactor: FavoritesListInteractorInput
    private let router: FavoritesListRouterProtocol
    private var cache: [MovieDetails] = []

    init(view: FavoritesListViewInput,
         interactor: FavoritesListInteractorInput,
         router: FavoritesListRouterProtocol) {
        self.view = view; self.interactor = interactor; self.router = router
    }

    func viewDidLoad() { interactor.load() }
    func viewWillAppear() { interactor.load() }

    func didSelect(row: Int) {
        guard cache.indices.contains(row) else { return }
        router.routeToDetails(movieID: cache[row].id)
    }

    func didDelete(row: Int) {
        guard cache.indices.contains(row) else { return }
        interactor.remove(id: cache[row].id)
    }

    // MARK: InteractorOutput
    func didLoad(items: [MovieDetails]) {
        cache = items
        let vms = items.map { FavoriteCellVM(id: $0.id,
                                             title: $0.originalTitle,
                                             rating: String(format: "%.1f ★", $0.voteAverage)) }
        view?.show(items: vms)
        view?.showEmpty(vms.isEmpty)
    }

    func didRemove(id: Int) {
        cache.removeAll { $0.id == id }
        didLoad(items: cache)
    }
}
