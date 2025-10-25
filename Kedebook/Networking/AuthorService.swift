//
//  AuthorService.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 25/10/25.
//

import Foundation

struct AuthorDetail: Decodable {
    let name: String
}

final class AuthorService {
    func fetchName(for authorKey: String) async throws -> String {
        // Normalize: ensure trailing ".json"
        let path = authorKey.hasSuffix(".json") ? authorKey : "\(authorKey).json"
        let urlString = "https://openlibrary.org\(path)"
        let detail: AuthorDetail = try await APIClient.shared.get(
            urlString: urlString,
            responseType: AuthorDetail.self
        )
        return detail.name
    }

    // Batch resolve with structured concurrency
    func fetchNames(for authorKeys: [String]) async -> [String] {
        guard !authorKeys.isEmpty else { return [] }
        var names: [String] = []
        names.reserveCapacity(authorKeys.count)

        await withTaskGroup(of: String?.self) { group in
            for key in authorKeys {
                group.addTask {
                    do { return try await self.fetchName(for: key) }
                    catch { return nil }
                }
            }
            for await maybeName in group {
                if let n = maybeName { names.append(n) }
            }
        }
        return names
    }
}
