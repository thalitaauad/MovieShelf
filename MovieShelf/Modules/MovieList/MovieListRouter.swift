//
//  MovieListRouter.swift
//  MovieShelf
//
//  Created by Thalita Auad on 06/11/25.
//

import UIKit

final class MovieListRouter: MovieListRouterProtocol {
    weak var viewController: UIViewController?
    private let deps: Deps
    init(deps: Deps) { self.deps = deps }

    func routeToDetails(movieID: Int) {
        let vc = MovieDetailViewController.make(movieID: movieID, deps: deps)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
