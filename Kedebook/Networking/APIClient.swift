//
//  APIClient.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 23/10/25.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)
}

class APIClient {
    static let shared = APIClient()
    enum APIError: Error { case invalidResponse, decodingFailed }

    func get<T: Decodable>(urlString: String, responseType: T.Type) async throws -> T {
        guard let url = URL(string: urlString) else { throw APIError.invalidResponse }
        var request = URLRequest(url: url)
        request.setValue("Kedebook (iOS)", forHTTPHeaderField: "User-Agent")

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw APIError.invalidResponse
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Decoding failed for \(urlString)")
            throw APIError.decodingFailed
        }
    }
}

