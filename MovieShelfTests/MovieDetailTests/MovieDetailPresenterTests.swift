//
//  MovieDetailPresenterTests.swift
//  MovieShelf
//
//  Created by Thalita Auad on 10/11/25.
//

import XCTest
@testable import MovieShelf

final class MovieDetailPresenterTests: XCTestCase {

    final class InteractorStub: MovieDetailInteractorInput {
        var output: MovieDetailInteractorOutput?

        var saved = false
        var detailsToLoad: MovieDetails = .init(
            id: 2, originalTitle: "Two", title: "Two",
            posterPath: nil, backdropPath: nil, overview: nil,
            releaseDate: nil, budget: nil, revenue: nil, voteAverage: 7.0
        )

        func loadDetails() { output?.didLoad(details: detailsToLoad) }

        func toggleFavorite() {
            saved.toggle()
            output?.didToggle(saved: saved)
        }

        func isSaved() -> Bool { saved }
    }

    func test_viewDidLoad_setsInitialSaved_andLoadsDetails() {
        let view = DetailViewSpy()
        let interactor = InteractorStub()
        let router = DetailRouterSpy()
        let sut = MovieDetailPresenter(view: view, interactor: interactor, router: router)
        interactor.output = sut

        sut.viewDidLoad()

        XCTAssertEqual(view.saved, false)
        XCTAssertEqual(view.details?.id, 2)
    }

    func test_didTapSave_whenSaved_asksAndNavigatesOnConfirm() {
        let view = DetailViewSpy()
        let interactor = InteractorStub()
        let router = DetailRouterSpy()
        let sut = MovieDetailPresenter(view: view, interactor: interactor, router: router)
        interactor.output = sut

        sut.viewDidLoad()
        sut.didTapSave()
        XCTAssertNotNil(view.askBlock)

        view.askBlock?()
        XCTAssertTrue(router.didRouteFavorites)
    }
}
