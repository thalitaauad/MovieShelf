//
//  FavoritesListContracts.swift
//  MovieShelf
//
//  Created by Thalita Auad on 07/11/25.
//

import Foundation

protocol FavoritesListViewInput: AnyObject {
    func show(items: [FavoriteCellVM])
    func showEmpty(_ on: Bool)
}

protocol FavoritesListViewOutput: AnyObject {
    func viewDidLoad()
    func viewWillAppear()              
    func didSelect(row: Int)
    func didDelete(row: Int)
}

protocol FavoritesListInteractorInput: AnyObject {
    func load()
    func remove(id: Int)
}

protocol FavoritesListInteractorOutput: AnyObject {
    func didLoad(items: [MovieDetails])
    func didRemove(id: Int)
}

protocol FavoritesListRouterProtocol: AnyObject {
    func routeToDetails(movieID: Int)
}
