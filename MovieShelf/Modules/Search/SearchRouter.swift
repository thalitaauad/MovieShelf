//
//  SearchRouter.swift
//  MovieShelf
//
//  Created by Thalita Auad on 06/11/25.
//

import UIKit

final class SearchRouter: SearchRouterProtocol {
    weak var viewController: UIViewController?
    private let deps: Deps
    init(deps: Deps) { self.deps = deps }

    func routeToResults(query: String) {
        viewController?.view.endEditing(true)

        let vc = MovieListViewController.make(initialQuery: query, deps: deps)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
