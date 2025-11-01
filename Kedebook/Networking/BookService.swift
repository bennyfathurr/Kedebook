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
        case title, author_name, cover_i, key
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try c.decode(String.self, forKey: .title)
        self.author_name = try? c.decode([String].self, forKey: .author_name)
        self.cover_i = try? c.decode(Int.self, forKey: .cover_i)
        self.id = try c.decode(String.self, forKey: .key)
    }

    init(id: String, title: String, author_name: [String]?, cover_i: Int?) {
        self.id = id
        self.title = title
        self.author_name = author_name
        self.cover_i = cover_i
    }

    func coverURL(size: CoverSize = .medium) -> URL? {
        guard let cover_i else { return nil }
        return URL(string: "https://covers.openlibrary.org/b/id/\(cover_i)-\(size.rawValue).jpg")
    }
}

// MARK: - Supporting Types
enum CoverSize: String {
    case small = "S", medium = "M", large = "L"
}

struct SubjectResponse: Decodable {
    let works: [Book]
}

struct SearchResponse: Decodable {
    let docs: [Book]
}

// MARK: - Service
class BookService {
    
    func fetchBooks(for category: String?) async throws -> [Book] {
        let query = category?.lowercased() ?? "book"
        let urlString = "https://openlibrary.org/search.json?q=\(query)&limit=15&fields=key,title,author_name,cover_i"

        guard let url = URL(string: urlString) else { throw URLError(.badURL) }

        var request = URLRequest(url: url)
        request.timeoutInterval = 10
        request.setValue("Kedebook (iOS)", forHTTPHeaderField: "User-Agent")

        let (data, _) = try await URLSession.shared.data(for: request)
        let decoded = try JSONDecoder().decode(SearchResponse.self, from: data)
        return decoded.docs
    }

    func searchBooks(query: String, limit: Int = 20) async throws -> [Book] {
            // Avoid empty search string crash
            guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return [] }

            let safeQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "book"
            let urlString = "https://openlibrary.org/search.json?q=\(safeQuery)&limit=\(limit)"

            guard let url = URL(string: urlString) else { return [] }
            let (data, _) = try await URLSession.shared.data(from: url)

            let decoded = try JSONDecoder().decode(SearchResponse.self, from: data)
            return decoded.docs
        }
}

extension BookService {
    func getBookDetails(workKey: String) async throws -> BookDetail {
            let trimmedKey = workKey.replacingOccurrences(of: "/works/", with: "")
            let urlString = "https://openlibrary.org/works/\(trimmedKey).json"

            guard let url = URL(string: urlString) else {
                throw URLError(.badURL)
            }

            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            return try decoder.decode(BookDetail.self, from: data)
        }
}
