//
//  TMDbAPIClient.swift
//  MovieShelf
//
//  Created by Thalita Auad on 06/11/25.
//

import Foundation

final class TMDbAPIClient: MoviesAPI {
    private let http: HTTPClient
    private let apiKey: String
    private let base: URL
    private let decoder = JSONDecoder()

    init(http: HTTPClient, apiKey: String) {
        self.http = http
        self.apiKey = apiKey
        guard let url = URL(string: "https://api.themoviedb.org/3") else {
            preconditionFailure("Invalid TMDB base URL")
        }
        self.base = url
    }

    private func makeURL(_ path: String, query: [URLQueryItem] = []) -> URL? {
        var comps = URLComponents(url: base.appendingPathComponent(path), resolvingAgainstBaseURL: false)
        var items = query
        items.append(.init(name: "api_key", value: apiKey))
        comps?.queryItems = items
        return comps?.url
    }

    func search(query: String, page: Int, completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = makeURL("search/movie",
                                query: [.init(name: "query", value: query),
                                        .init(name: "page",  value: String(page))]) else {
            completion(.failure(URLError(.badURL)))
            return
        }

        http.get(url: url) { result in
            switch result {
            case .failure(let erro):
                completion(.failure(erro))
            case .success(let data):
                DispatchQueue.global(qos: .userInitiated).async {
                    let mapped: Result<[Movie], Error> = Result {
                        let dto = try self.decoder.decode(SearchResponseDTO.self, from: data)
                        return dto.results.map {
                            Movie(id: $0.id,
                                  originalTitle: $0.originalTitle,
                                  posterPath: $0.posterPath,
                                  voteAverage: $0.voteAverage)
                        }
                    }
                    DispatchQueue.main.async { completion(mapped) }
                }
            }
        }
    }

    func details(id: Int, completion: @escaping (Result<MovieDetails, Error>) -> Void) {
        guard let url = makeURL("movie/\(id)") else {
            completion(.failure(URLError(.badURL)))
            return
        }

        http.get(url: url) { result in
            switch result {
            case .failure(let e):
                completion(.failure(e))
            case .success(let data):
                DispatchQueue.global(qos: .userInitiated).async {
                    let mapped: Result<MovieDetails, Error> = Result {
                        let detail = try self.decoder.decode(MovieDetailsDTO.self, from: data)
                        return MovieDetails(
                            id: detail.id,
                            originalTitle: detail.originalTitle,
                            title: detail.title,
                            posterPath: detail.posterPath,
                            backdropPath: detail.backdropPath,
                            overview: detail.overview,
                            releaseDate: detail.releaseDate,
                            budget: detail.budget,
                            revenue: detail.revenue,
                            voteAverage: detail.voteAverage
                        )
                    }
                    DispatchQueue.main.async { completion(mapped) }
                }
            }
        }
    }
}
