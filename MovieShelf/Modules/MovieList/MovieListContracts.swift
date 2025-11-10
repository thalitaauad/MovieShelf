//
//  MovieListContracts.swift
//  MovieShelf
//
//  Created by Thalita Auad on 06/11/25.
//

import Foundation

protocol MovieListViewInput: AnyObject {
    func showLoading(_ on: Bool)
    func show(items: [MovieCellVM])
    func showError(_ message: String)
}

protocol MovieListViewOutput: AnyObject {
    func viewDidLoad()
    func didSelect(id: Int)
    func didToggleFavorite(id: Int)
}

protocol MovieListInteractorInput: AnyObject {
    func start()
    func isFavorite(id: Int) -> Bool
    func toggleFavorite(id: Int, completion: @escaping (Bool) -> Void) 
}

protocol MovieListInteractorOutput: AnyObject {
    func didLoad(movies: [Movie])
    func didFail(_ error: Error)
}

protocol MovieListRouterProtocol: AnyObject {
    func routeToDetails(movieID: Int)
}
