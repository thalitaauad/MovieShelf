//
//  SearchPresenter.swift
//  MovieShelf
//
//  Created by Thalita Auad on 06/11/25.
//

import Foundation

final class SearchPresenter: SearchViewOutput {
    private weak var view: SearchViewInput?
    private let interactor: SearchInteractorInput
    private let router: SearchRouterProtocol
    private var query = ""
    private var pendingWork: DispatchWorkItem?

    init(view: SearchViewInput, interactor: SearchInteractorInput, router: SearchRouterProtocol) {
        self.view = view; self.interactor = interactor; self.router = router
    }

    func viewDidLoad() {
        view?.setButtonEnabled(false); view?.showError(nil)
    }

    func didChangeQuery(_ text: String) {
        query = interactor.normalize(text)
        let valid = interactor.isValid(query)
        view?.setButtonEnabled(valid)
        view?.showError(query.isEmpty || valid ? nil : "Type at least 2 characters")

        pendingWork?.cancel()
        let w = DispatchWorkItem { [weak self] in _ = self?.query }
        pendingWork = w
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35, execute: w)
    }

    func didTapSearch() { go() }
    func didPressReturn() { go() }

    private func go() {
        guard interactor.isValid(query) else {
            view?.setButtonEnabled(false)
            view?.showError("Please type at least 2 characters")
            return
        }
        interactor.recordSearch(query)
        router.routeToResults(query: query)
    }
}
