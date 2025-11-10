//
//  MovieListInteractorTests.swift
//  MovieShelf
//
//  Created by Thalita Auad on 10/11/25.
//

import XCTest
@testable import MovieShelf

final class MovieListInteractorTests: XCTestCase {

    final class OutputSpy: MovieListInteractorOutput {
        private(set) var loaded: [Movie]?
        private(set) var failed: Error?
        func didLoad(movies: [Movie]) { loaded = movies }
        func didFail(_ error: Error) { failed = error }
    }

    func test_start_callsAPI_andForwardsSuccess() {
        let api = MoviesAPIMock()
        api.searchStub = .success([Movie(id: 1, originalTitle: "A", posterPath: nil, voteAverage: 7.0)])
        let favs = FavoritesMock()
        let sut = MovieListInteractor(api: api, favs: favs, initialQuery: "star")
        let out = OutputSpy()
        sut.output = out

        sut.start()

        XCTAssertEqual(api.lastSearch?.query, "star")
        XCTAssertEqual(api.lastSearch?.page, 1)
        XCTAssertEqual(out.loaded?.count, 1)
        XCTAssertNil(out.failed)
    }

    func test_start_forwardsError() {
        let api = MoviesAPIMock()
        api.searchStub = .failure(NSError(domain: "x", code: -1))
        let favs = FavoritesMock()
        let sut = MovieListInteractor(api: api, favs: favs, initialQuery: "q")
        let out = OutputSpy()
        sut.output = out

        sut.start()

        XCTAssertNotNil(out.failed)
        XCTAssertNil(out.loaded)
    }

    func test_isFavorite_readsFromFavoritesStore() {
        let api = MoviesAPIMock()
        let favs = FavoritesMock()
        let minimal = MovieDetails(id: 99, originalTitle: "", title: "", posterPath: nil, backdropPath: nil,
                                   overview: nil, releaseDate: nil, budget: nil, revenue: nil, voteAverage: 0)
        favs.toggle(details: minimal) { _ in }

        let sut = MovieListInteractor(api: api, favs: favs, initialQuery: "x")

        XCTAssertTrue(sut.isFavorite(id: 99))
        XCTAssertFalse(sut.isFavorite(id: 100))
    }

    func test_toggleFavorite_returnsNewState_viaCompletion() {
        let api = MoviesAPIMock()
        let favs = FavoritesMock()
        let sut = MovieListInteractor(api: api, favs: favs, initialQuery: "x")

        let exp1 = expectation(description: "toggle to saved")
        sut.toggleFavorite(id: 5) { saved in
            XCTAssertTrue(saved)
            exp1.fulfill()
        }
        wait(for: [exp1], timeout: 0.1)

        let exp2 = expectation(description: "toggle to removed")
        sut.toggleFavorite(id: 5) { saved in
            XCTAssertFalse(saved)
            exp2.fulfill()
        }
        wait(for: [exp2], timeout: 0.1)
    }
}
