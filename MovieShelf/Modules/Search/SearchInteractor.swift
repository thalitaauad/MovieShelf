//
//  SearchInteractor.swift
//  MovieShelf
//
//  Created by Thalita Auad on 06/11/25.
//

import Foundation

final class SearchInteractor: SearchInteractorInput {
    private let minLength = 2
    func normalize(_ text: String) -> String {
        text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    func isValid(_ query: String) -> Bool { query.count >= minLength }
    func recordSearch(_ query: String) { }
}
