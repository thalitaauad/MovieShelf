//
//  Mocks.swift
//  MovieShelf
//
//  Created by Thalita Auad on 10/11/25.
//

import UIKit
@testable import MovieShelf

// MARK: - API mock
final class MoviesAPIMock: MoviesAPI {
    var searchStub: Result<[Movie], Error> = .success([])
    var detailsStub: Result<MovieDetails, Error> = .failure(NSError(domain: "", code: -1))

    private(set) var lastSearch: (query: String, page: Int)?
    private(set) var lastDetailsID: Int?

    func search(query: String, page: Int, completion: @escaping (Result<[Movie], Error>) -> Void) {
        lastSearch = (query, page)
        completion(searchStub)
    }
    func details(id: Int, completion: @escaping (Result<MovieDetails, Error>) -> Void) {
        lastDetailsID = id
        completion(detailsStub)
    }
}

// MARK: - Favorites mock
final class FavoritesMock: FavoritesStoring {
    private var store: [Int: MovieDetails] = [:]

    func toggle(details: MovieShelf.MovieDetails, completion: @escaping (Bool) -> Void) {
        if store[details.id] != nil {
            store[details.id] = nil
            completion(false)
        } else {
            store[details.id] = details
            completion(true)
        }
    }

    func isSaved(id: Int) -> Bool { store[id] != nil }

    func toggle(details: MovieDetails, completion: @escaping () -> Void) {
        if isSaved(id: details.id) { store[details.id] = nil } else { store[details.id] = details }
        completion()
    }

    func all(completion: @escaping ([MovieDetails]) -> Void) {
        completion(Array(store.values))
    }

    func remove(id: Int, completion: @escaping () -> Void) {
        store[id] = nil
        completion()
    }
}

// MARK: - Image loader mock
final class ImageLoaderMock: ImageLoading {
    var lastURL: URL?
    func load(url: URL, completion: @escaping (UIImage?) -> Void) { lastURL = url; completion(UIImage()) }
}

// MARK: - Spies de View e Router

 final class SearchViewSpy: SearchViewInput {
    private(set) var buttonEnabled: Bool?
    private(set) var lastError: String?

    func setButtonEnabled(_ enabled: Bool) { buttonEnabled = enabled }
    func showError(_ message: String?) { lastError = message }
}

 final class SearchRouterSpy: SearchRouterProtocol {
    private(set) var routedQuery: String?
    func routeToResults(query: String) { routedQuery = query }
}

 final class SearchInteractorSpy: SearchInteractorInput {
    func isValid(_ query: String) -> Bool { query.count >= 2 }
    func normalize(_ text: String) -> String {
        text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    private(set) var recorded: [String] = []
    func recordSearch(_ query: String) { recorded.append(query) }
}

final class MovieListViewSpy: MovieListViewInput {
    private(set) var loading: Bool?
    private(set) var items: [MovieCellVM] = []
    private(set) var error: String?
    func showLoading(_ on: Bool) { loading = on }
    func show(items: [MovieCellVM]) { self.items = items }
    func showError(_ message: String) { error = message }
}
final class MovieListRouterSpy: MovieListRouterProtocol {
    private(set) var routedID: Int?
    func routeToDetails(movieID: Int) { routedID = movieID }
}

final class DetailViewSpy: MovieDetailViewInput {

    private(set) var loading: Bool?
    private(set) var saved: Bool?
    private(set) var details: MovieDetails?
    private(set) var error: String?
    private(set) var askBlock: (() -> Void)?

    func showLoading(_ on: Bool) { loading = on }
    func show(details: MovieDetails) { self.details = details }
    func setSaved(_ saved: Bool) { self.saved = saved }
    func askNavigateToFavorites(onConfirm: @escaping () -> Void) { askBlock = onConfirm }
    func showError(_ message: String) { error = message }
    func askNavigateToFavorites(saved: Bool, onConfirm: @escaping () -> Void) {
        self.saved = saved
        self.askBlock = onConfirm
    }
}
final class DetailRouterSpy: MovieDetailRouterProtocol {
    private(set) var didRouteFavorites = false
    func routeToFavorites() { didRouteFavorites = true }
}

final class FavoritesViewSpy: FavoritesListViewInput {
    private(set) var items: [FavoriteCellVM] = []
    private(set) var isEmptyShown: Bool?
    func show(items: [FavoriteCellVM]) { self.items = items }
    func showEmpty(_ on: Bool) { isEmptyShown = on }
}
final class FavoritesRouterSpy: FavoritesListRouterProtocol {
    private(set) var routedID: Int?
    func routeToDetails(movieID: Int) { routedID = movieID }
}
