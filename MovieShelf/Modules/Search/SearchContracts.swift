//
//  SearchContracts.swift
//  MovieShelf
//
//  Created by Thalita Auad on 06/11/25.
//

import Foundation

protocol SearchViewInput: AnyObject {
    func setButtonEnabled(_ enabled: Bool)
    func showError(_ message: String?)
}

protocol SearchViewOutput: AnyObject {
    func viewDidLoad()
    func didChangeQuery(_ text: String)
    func didTapSearch()
    func didPressReturn()
}

protocol SearchInteractorInput: AnyObject {
    func normalize(_ text: String) -> String
    func isValid(_ query: String) -> Bool
    func recordSearch(_ query: String)
}

protocol SearchRouterProtocol: AnyObject {
    func routeToResults(query: String)
}
