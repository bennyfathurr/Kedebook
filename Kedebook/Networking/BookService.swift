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
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let urlString = "https://openlibrary.org/search.json?q=\(encodedQuery)"
        let response: BookSearchResponse = try await APIClient.shared.get(
            urlString: urlString,
            responseType: BookSearchResponse.self
        )
        return response.docs
    }

    func getBookDetails(workKey: String) async throws -> BookDetail {
        var key = workKey
        if !key.hasPrefix("/") { key = "/" + key } // ensure leading slash
        if !key.hasSuffix(".json") { key += ".json" } // ensure .json
        
        let urlString = "https://openlibrary.org\(key)"
        let detail: BookDetail = try await APIClient.shared.get(
            urlString: urlString,
            responseType: BookDetail.self
        )
        print("📘 Fetching details from: \(urlString)")
        return detail
    }

}
