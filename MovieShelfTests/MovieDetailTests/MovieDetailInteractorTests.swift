//
//  MovieDetailInteractorTests.swift
//  MovieShelf
//
//  Created by Thalita Auad on 10/11/25.
//

import XCTest
@testable import MovieShelf

final class MovieDetailInteractorTests: XCTestCase {

    final class OutputSpy: MovieDetailInteractorOutput {
        var details: MovieDetails?
        var err: Error?
        var toggled: Bool?

        func didLoad(details: MovieDetails) { self.details = details }
        func didFail(_ error: Error) { err = error }
        func didToggle(saved: Bool) { toggled = saved }
    }

    func test_loadDetails_callsAPI_andOutputsDetails() {
        let api = MoviesAPIMock()
        let d = MovieDetails(id: 10, originalTitle: "Ten", title: "Ten",
                             posterPath: nil, backdropPath: nil, overview: nil,
                             releaseDate: nil, budget: nil, revenue: nil, voteAverage: 6.0)
        api.detailsStub = .success(d)

        let favs = FavoritesMock()
        let sut = MovieDetailInteractor(api: api, favs: favs, movieID: 10)
        let out = OutputSpy(); sut.output = out

        sut.loadDetails()

        XCTAssertEqual(api.lastDetailsID, 10)
        XCTAssertEqual(out.details?.id, 10)
        XCTAssertNil(out.err)
    }

    func test_toggleFavorite_togglesAndReturnsCurrentState() {
        let api = MoviesAPIMock()
        let details = MovieDetails(id: 1, originalTitle: "One", title: "One",
                                   posterPath: nil, backdropPath: nil, overview: nil,
                                   releaseDate: nil, budget: nil, revenue: nil, voteAverage: 6.0)
        api.detailsStub = .success(details)

        let favs = FavoritesMock()
        let sut = MovieDetailInteractor(api: api, favs: favs, movieID: 1)
        let out = OutputSpy(); sut.output = out

        sut.loadDetails()

        sut.toggleFavorite()
        XCTAssertEqual(out.toggled, true)

        sut.toggleFavorite()
        XCTAssertEqual(out.toggled, false)
    }
}
