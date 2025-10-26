//
//  BookService.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 25/10/25.
//

import Foundation

// MARK: - Model
struct Book: Identifiable, Decodable {
    let id: String
    let title: String
    let author_name: [String]?
    let cover_i: Int?

    enum CodingKeys: String, CodingKey {
        case title
        case author_name
        case cover_i
        case key
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.author_name = try? container.decode([String].self, forKey: .author_name)
        self.cover_i = try? container.decode(Int.self, forKey: .cover_i)
        self.id = try container.decode(String.self, forKey: .key)
    }

    func coverURL(size: CoverSize = .medium) -> URL? {
        guard let cover_i = cover_i else { return nil }
        return URL(string: "https://covers.openlibrary.org/b/id/\(cover_i)-\(size.rawValue).jpg")
    }
}

// MARK: - Supporting Types
enum CoverSize: String {
    case small = "S"
    case medium = "M"
    case large = "L"
}

struct BookSearchResponse: Decodable {
    let docs: [Book]
}

// MARK: - Service
class BookService {
    func searchBooks(query: String) async throws -> [Book] {
        // Encode query safely
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query

        // Use exact phrase matching to improve relevance
        let urlString = "https://openlibrary.org/search.json?q=\"\(encodedQuery)\"&has_fulltext=true"

        // Fetch
        let response: BookSearchResponse = try await APIClient.shared.get(
            urlString: urlString,
            responseType: BookSearchResponse.self
        )

        // Filter out irrelevant or incomplete results
        let filtered = response.docs.filter {
            !$0.title.isEmpty &&
            !($0.author_name?.isEmpty ?? true) &&
            !$0.id.isEmpty
        }

        // Sort by rough relevance
        let ranked = filtered.sorted {
            relevanceScore(for: $0, query: query) > relevanceScore(for: $1, query: query)
        }

        return ranked
    }

    private func relevanceScore(for book: Book, query: String) -> Int {
        let lower = query.lowercased()
        var score = 0
        if book.title.lowercased().contains(lower) { score += 10 }
        if let authors = book.author_name,
           authors.joined(separator: " ").lowercased().contains(lower) { score += 5 }
        return score
    }

    func getBookDetails(workKey: String) async throws -> BookDetail {
        var key = workKey
        if !key.hasPrefix("/") { key = "/" + key } // ensure leading slash
        if !key.hasSuffix(".json") { key += ".json" } // ensure .json
        
        let urlString = "https://openlibrary.org\(key)"
        print("📘 Fetching details from:", urlString)

        let detail: BookDetail = try await APIClient.shared.get(
            urlString: urlString,
            responseType: BookDetail.self
        )

        return detail
    }
}
