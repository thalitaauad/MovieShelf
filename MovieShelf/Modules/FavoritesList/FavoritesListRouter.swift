//
//  FavoritesListRouter.swift
//  MovieShelf
//
//  Created by Thalita Auad on 07/11/25.
//

import UIKit

final class FavoritesListRouter: FavoritesListRouterProtocol {
    weak var viewController: UIViewController?
    private let deps: Deps
    init(deps: Deps) { self.deps = deps }

    func routeToDetails(movieID: Int) {
        let vc = MovieDetailViewController.make(movieID: movieID, deps: deps)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
