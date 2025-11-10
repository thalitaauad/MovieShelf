//
//  MovieDetailRouter.swift
//  MovieShelf
//
//  Created by Thalita Auad on 08/11/25.
//

import UIKit

final class MovieDetailRouter: MovieDetailRouterProtocol {
    weak var viewController: UIViewController?
    private let deps: Deps
    init(deps: Deps) { self.deps = deps }

    func routeToFavorites() {
        let vc = FavoritesListViewController.make(deps: deps)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
