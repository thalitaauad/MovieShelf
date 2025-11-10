//
//  SearchTest.swift
//  MovieShelfTests
//
//  Created by Thalita Auad on 10/11/25.
//

import XCTest
@testable import MovieShelf

final class SearchPresenterTests: XCTestCase {

    private func makeSUT() -> (SearchPresenter, SearchViewSpy, SearchRouterSpy, SearchInteractorSpy) {
        let view = SearchViewSpy()
        let interactor = SearchInteractorSpy()
        let router = SearchRouterSpy()
        let sut = SearchPresenter(view: view, interactor: interactor, router: router)
        return (sut, view, router, interactor)
    }

    func test_viewDidLoad_startsDisabled_andClearsError() {
        let (sut, view, _, _) = makeSUT()

        sut.viewDidLoad()

        XCTAssertEqual(view.buttonEnabled, false)
        XCTAssertNil(view.lastError)
    }

    func test_didChangeQuery_updatesUI_forInvalidAndValid() {
        let (sut, view, _, _) = makeSUT()

        sut.didChangeQuery("a")
        XCTAssertEqual(view.buttonEnabled, false)
        XCTAssertEqual(view.lastError, "Type at least 2 characters")

        sut.didChangeQuery("ab")
        XCTAssertEqual(view.buttonEnabled, true)
        XCTAssertNil(view.lastError)
    }

    func test_didTapSearch_withInvalidQuery_showsError_andDoesNotRoute() {
        let (sut, view, router, _) = makeSUT()

        sut.didChangeQuery("a")
        sut.didTapSearch()

        XCTAssertNil(router.routedQuery)
        XCTAssertEqual(view.buttonEnabled, false)
        XCTAssertEqual(view.lastError, "Please type at least 2 characters")
    }

    func test_didPressReturn_withValidQuery_routesAndRecords() {
        let (sut, _, router, interactor) = makeSUT()

        sut.didChangeQuery("star wars")
        sut.didPressReturn()

        XCTAssertEqual(router.routedQuery, "star wars")
        XCTAssertEqual(interactor.recorded, ["star wars"])
    }

    func test_normalize_trimsSpaces_beforeRouting() {
        let (sut, _, router, interactor) = makeSUT()

        sut.didChangeQuery("   dune  ")
        sut.didTapSearch()

        XCTAssertEqual(router.routedQuery, "dune")
        XCTAssertEqual(interactor.recorded, ["dune"])
    }
}
