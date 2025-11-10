//
//  MovieDetailContracts.swift
//  MovieShelf
//
//  Created by Thalita Auad on 06/11/25.
//

import Foundation

protocol MovieDetailViewInput: AnyObject {
    func showLoading(_ on: Bool)
    func show(details: MovieDetails)
    func setSaved(_ saved: Bool)
    func showError(_ message: String)
    func askNavigateToFavorites(saved: Bool, onConfirm: @escaping () -> Void)
}

protocol MovieDetailViewOutput: AnyObject {
    func viewDidLoad()
    func didTapSave()
}

protocol MovieDetailInteractorInput: AnyObject {
    func loadDetails()
    func toggleFavorite()
    func isSaved() -> Bool
}

protocol MovieDetailInteractorOutput: AnyObject {
    func didLoad(details: MovieDetails)
    func didFail(_ error: Error)
    func didToggle(saved: Bool)
}

protocol MovieDetailRouterProtocol: AnyObject {
    func routeToFavorites()
}

