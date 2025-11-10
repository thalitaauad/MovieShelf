//
//  MovieListPresenterTests.swift
//  MovieShelf
//
//  Created by Thalita Auad on 10/11/25.
//

import XCTest
@testable import MovieShelf

final class MovieListPresenterTests: XCTestCase {

    final class InteractorStub: MovieListInteractorInput {
        var output: MovieListInteractorOutput?

        var result: Result<[Movie], Error> = .success([])
        var favs: Set<Int> = []
        private(set) var startCalledCount = 0
        private(set) var lastToggled: Int?

        func start() {
            startCalledCount += 1
            switch result {
            case .success(let movies): output?.didLoad(movies: movies)
            case .failure(let e):      output?.didFail(e)
            }
        }

        func isFavorite(id: Int) -> Bool { favs.contains(id) }

        func toggleFavorite(id: Int, completion: @escaping (Bool) -> Void) {
            lastToggled = id
            let nowFav = !favs.contains(id)
            if nowFav { favs.insert(id) } else { favs.remove(id) }
            completion(nowFav)
        }
    }

    func test_viewDidLoad_showsLoading_thenMapsMoviesAndFavs() {
        let view = MovieListViewSpy()
        let interactor = InteractorStub()
        let router = MovieListRouterSpy()
        let sut = MovieListPresenter(view: view, interactor: interactor, router: router)
        interactor.output = sut

        interactor.result = .success([
            Movie(id: 1, originalTitle: "Inception",  posterPath: "/x.png", voteAverage: 8.8),
            Movie(id: 2, originalTitle: "Interstellar", posterPath: nil,   voteAverage: 8.6),
        ])
        interactor.favs = [2]

        sut.viewDidLoad()

        XCTAssertEqual(view.loading, false)
        XCTAssertEqual(view.items.count, 2)
        XCTAssertEqual(view.items[0].title, "Inception")
        XCTAssertEqual(view.items[0].rating, "8.8 ★")
        XCTAssertEqual(view.items[0].isFavorite, false)
        XCTAssertEqual(view.items[1].isFavorite, true)
    }

    func test_didSelect_routesToDetails() {
        let view = MovieListViewSpy()
        let interactor = InteractorStub()
        let router = MovieListRouterSpy()
        let sut = MovieListPresenter(view: view, interactor: interactor, router: router)
        interactor.output = sut

        interactor.result = .success([Movie(id: 42, originalTitle: "The Answer", posterPath: nil, voteAverage: 7.0)])

        sut.viewDidLoad()
        sut.didSelect(id: 42)

        XCTAssertEqual(router.routedID, 42)
    }

    func test_interactorFailure_showsError_andStopsLoading() {
        let view = MovieListViewSpy()
        let interactor = InteractorStub()
        let router = MovieListRouterSpy()
        let sut = MovieListPresenter(view: view, interactor: interactor, router: router)
        interactor.output = sut

        interactor.result = .failure(NSError(domain: "x", code: -1))

        sut.viewDidLoad()

        XCTAssertEqual(view.loading, false)
        XCTAssertEqual(view.error, "Couldn’t load. Try again.")
    }

    func test_didToggleFavorite_callsInteractor_andReloadsList() {
        let view = MovieListViewSpy()
        let interactor = InteractorStub()
        let router = MovieListRouterSpy()
        let sut = MovieListPresenter(view: view, interactor: interactor, router: router)
        interactor.output = sut

        interactor.result = .success([Movie(id: 7, originalTitle: "Se7en", posterPath: nil, voteAverage: 8.6)])

        sut.viewDidLoad()
        let startCallsBefore = interactor.startCalledCount

        sut.didToggleFavorite(id: 7)

        XCTAssertEqual(interactor.lastToggled, 7)
        XCTAssertEqual(interactor.startCalledCount, startCallsBefore + 1)
    }
}
