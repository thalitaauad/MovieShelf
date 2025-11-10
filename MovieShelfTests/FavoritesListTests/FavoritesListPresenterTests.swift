//
//  FavoritesListPresenterTests.swift
//  MovieShelf
//
//  Created by Thalita Auad on 10/11/25.
//

import XCTest
@testable import MovieShelf

final class FavoritesListPresenterTests: XCTestCase {
    final class InteractorStub: FavoritesListInteractorInput {
        var output: FavoritesListInteractorOutput?
        var items: [MovieDetails] = []
        func load() { output?.didLoad(items: items) }
        func remove(id: Int) {
            items.removeAll { $0.id == id }
            output?.didRemove(id: id)
        }
    }

    func test_viewDidLoad_loads_andShowsItems_andEmptyState() {
        let view = FavoritesViewSpy()
        let interactor = InteractorStub()
        let router = FavoritesRouterSpy()
        let sut = FavoritesListPresenter(view: view, interactor: interactor, router: router)
        interactor.output = sut

        interactor.items = [
            .init(id: 5, originalTitle: "Five", title: "Five", posterPath: nil, backdropPath: nil,
                  overview: nil, releaseDate: nil, budget: nil, revenue: nil, voteAverage: 9.1)
        ]
        sut.viewDidLoad()
        XCTAssertEqual(view.items.count, 1)
        XCTAssertEqual(view.isEmptyShown, false)

        interactor.items = []
        sut.viewWillAppear()
        XCTAssertEqual(view.items.count, 0)
        XCTAssertEqual(view.isEmptyShown, true)
    }

    func test_didSelect_routesToDetails() {
        let view = FavoritesViewSpy()
        let interactor = InteractorStub()
        interactor.items = [.init(id: 99, originalTitle: "Ninety Nine", title: "99",
                                  posterPath: nil, backdropPath: nil, overview: nil, releaseDate: nil,
                                  budget: nil, revenue: nil, voteAverage: 8.0)]
        let router = FavoritesRouterSpy()
        let sut = FavoritesListPresenter(view: view, interactor: interactor, router: router)
        interactor.output = sut

        sut.viewDidLoad()
        sut.didSelect(row: 0)
        XCTAssertEqual(router.routedID, 99)
    }

    func test_didDelete_callsInteractor_andUpdatesView() {
        let view = FavoritesViewSpy()
        let interactor = InteractorStub()
        interactor.items = [
            .init(id: 1, originalTitle: "One", title: "One", posterPath: nil, backdropPath: nil, overview: nil, releaseDate: nil, budget: nil, revenue: nil, voteAverage: 6.0),
            .init(id: 2, originalTitle: "Two", title: "Two", posterPath: nil, backdropPath: nil, overview: nil, releaseDate: nil, budget: nil, revenue: nil, voteAverage: 7.0),
        ]
        let router = FavoritesRouterSpy()
        let sut = FavoritesListPresenter(view: view, interactor: interactor, router: router)
        interactor.output = sut

        sut.viewDidLoad()
        XCTAssertEqual(view.items.count, 2)

        sut.didDelete(row: 0)
        XCTAssertEqual(view.items.count, 1)
    }
}
