//
//  FavoritesStoringProtocol.swift
//  MovieShelf
//
//  Created by Thalita Auad on 06/11/25.
//

public protocol FavoritesStoring {
    func isSaved(id: Int) -> Bool
    func toggle(details: MovieDetails, completion: @escaping (_ isSavedNow: Bool) -> Void)
    func all(completion: @escaping ([MovieDetails]) -> Void)
    func remove(id: Int, completion: @escaping () -> Void)
}
