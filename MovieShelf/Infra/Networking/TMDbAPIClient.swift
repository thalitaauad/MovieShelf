//
//  TMDbAPIClient.swift
//  MovieShelf
//
//  Created by Thalita Auad on 06/11/25.
//

import Foundation

private struct SearchResponseDTO: Decodable { let results: [MovieDTO] }
private struct MovieDTO: Decodable {
    let id: Int
    let original_title: String
    let poster_path: String?
    let vote_average: Double
}
private struct MovieDetailsDTO: Decodable {
    let id: Int
    let original_title: String
    let title: String
    let poster_path: String?
    let backdrop_path: String?
    let overview: String?
    let release_date: String?
    let budget: Int?
    let revenue: Int?
    let vote_average: Double
}

final class TMDbAPIClient: MoviesAPI {
    private let http: HTTPClient
    private let apiKey: String
    private let base: URL

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
        items.append(URLQueryItem(name: "api_key", value: apiKey))
        comps?.queryItems = items
        return comps?.url
    }

    func search(query: String, page: Int, completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = makeURL("search/movie",
                                        query: [URLQueryItem(name: "query", value: query),
                                                URLQueryItem(name: "page", value: String(page))]) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        http.get(url: url) { result in
            switch result {
            case .failure(let erro): completion(.failure(erro))
            case .success(let data):
                DispatchQueue.global(qos: .userInitiated).async {
                    let mapped: Result<[Movie], Error> = Result {
                        let dto = try JSONDecoder().decode(SearchResponseDTO.self, from: data)
                        return dto.results.map {
                            Movie(id: $0.id, originalTitle: $0.original_title,
                                  posterPath: $0.poster_path, voteAverage: $0.vote_average)
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
            case .failure(let erro): completion(.failure(erro))
            case .success(let data):
                DispatchQueue.global(qos: .userInitiated).async {
                    let mapped: Result<MovieDetails, Error> = Result {
                        let details = try JSONDecoder().decode(MovieDetailsDTO.self, from: data)
                        return MovieDetails(
                            id: details.id,
                            originalTitle: details.original_title,
                            title: details.title,
                            posterPath: details.poster_path, backdropPath: details.backdrop_path, overview: details.overview, releaseDate: details.release_date, budget: details.budget, revenue: details.revenue, voteAverage: details.vote_average)
                    }
                    DispatchQueue.main.async { completion(mapped) }
                }
            }
        }
    }
}
