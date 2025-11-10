//
//  Dependencies.swift
//  MovieShelf
//
//  Created by Thalita Auad on 06/11/25.
//

import UIKit

struct Deps {
    let api: MoviesAPI
    let favs: FavoritesStoring
    let imageLoader: ImageLoading
}

struct Dependencies {
    let deps: Deps

    init?(app: UIApplication) {
        guard
            let appDelegate = app.delegate as? AppDelegate,
            let ctx = appDelegate.modelContext
        else { return nil }

        let http = HTTPClient()
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "TMDB_API_KEY") as? String ?? ""
        if apiKey.isEmpty {
            print("⚠️ Missing TMDB_API_KEY in Info.plist/.xcconfig")
            return nil
        }
        let api = TMDbAPIClient(http: http, apiKey: apiKey)
        let favs = SwiftDataFavoritesRepo(context: ctx)
        self.deps = Deps(api: api, favs: favs, imageLoader: ImageLoader.shared)
    }
}
