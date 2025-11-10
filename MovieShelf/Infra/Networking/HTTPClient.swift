//
//  HTTPClient.swift
//  MovieShelf
//
//  Created by Thalita Auad on 06/11/25.
//

import Foundation

final class HTTPClient {
    private let session: URLSession = .shared

    func get(url: URL,
             headers: [String:String] = [:],
             completion: @escaping (Result<Data, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 30
        headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }

        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let http = response as? HTTPURLResponse,
                      (200...299).contains(http.statusCode) else {
                    completion(.failure(NSError(domain: "http",
                                                code: (response as? HTTPURLResponse)?.statusCode ?? -1)))
                    return
                }
                completion(.success(data ?? Data()))
            }
        }.resume()
    }
}
