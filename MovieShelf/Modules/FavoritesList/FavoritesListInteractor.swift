//
//  FavoritesListInteractor.swift
//  MovieShelf
//
//  Created by Thalita Auad on 07/11/25.
//

import Foundation

final class FavoritesListInteractor: FavoritesListInteractorInput {
    weak var output: FavoritesListInteractorOutput?

    private let favs: FavoritesStoring
    init(favs: FavoritesStoring) { self.favs = favs }

    func load() {
        favs.all { [weak self] details in
            self?.output?.didLoad(items: details)
        }
    }

    func remove(id: Int) {
        favs.remove(id: id) { [weak self] in
            self?.output?.didRemove(id: id)
        }
    }
}
