//
//  SwiftDataFavorites.swift
//  MovieShelf
//
//  Created by Thalita Auad on 06/11/25.
//

import Foundation
import SwiftData

final class SwiftDataFavoritesRepo: FavoritesStoring {
    private let ctx: ModelContext
    init(context: ModelContext) { self.ctx = context }

    func isSaved(id: Int) -> Bool {
        let fetch = FetchDescriptor<FavoriteMovie>(
            predicate: #Predicate<FavoriteMovie> { $0.id == id }
        )
        return (try? ctx.fetch(fetch)).map { !$0.isEmpty } ?? false
    }

    func toggle(details: MovieDetails, completion: @escaping (_ nowSaved: Bool) -> Void) {
        let id = details.id
        DispatchQueue.main.async {
            let fetch = FetchDescriptor<FavoriteMovie>(
                predicate: #Predicate<FavoriteMovie> { $0.id == id }
            )
            do {
                if let existing = try self.ctx.fetch(fetch).first {
                    self.ctx.delete(existing)
                    try self.ctx.save()
                    completion(false)
                } else {
                    self.ctx.insert(FavoriteMovie(from: details))
                    try self.ctx.save()
                    completion(true)
                }
            } catch {
                print("SwiftData toggle error:", error)
                completion(self.isSaved(id: id)) 
            }
        }
    }

    func all(completion: @escaping ([MovieDetails]) -> Void) {
        DispatchQueue.main.async {
            let fetch = FetchDescriptor<FavoriteMovie>(
                sortBy: [.init(\.createdAt, order: .reverse)]
            )
            let items = (try? self.ctx.fetch(fetch)) ?? []
            completion(items.map { $0.asDomain })
        }
    }

    func remove(id: Int, completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            let fetch = FetchDescriptor<FavoriteMovie>(
                predicate: #Predicate<FavoriteMovie> { $0.id == id }
            )
            if let hit = try? self.ctx.fetch(fetch).first {
                self.ctx.delete(hit)
                try? self.ctx.save()
            }
            completion()
        }
    }
}
