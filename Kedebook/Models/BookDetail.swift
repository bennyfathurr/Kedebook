//
//  BookDetail.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 25/10/25.
//

import Foundation

struct BookDetail: Decodable {
    let title: String
    let descriptionText: String
    let authors: [AuthorReference]?
    let covers: [Int]?

    struct AuthorReference: Decodable {
        let author: AuthorKey
    }

    struct AuthorKey: Decodable {
        let key: String
    }

    enum CodingKeys: String, CodingKey {
        case title, description, authors, covers
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? "Unknown Title"
        authors = try? container.decodeIfPresent([AuthorReference].self, forKey: .authors)
        covers = try? container.decodeIfPresent([Int].self, forKey: .covers)

        // Handle description as either string or object
        if let descString = try? container.decode(String.self, forKey: .description) {
            descriptionText = descString
        } else if let descObject = try? container.decode([String: String].self, forKey: .description),
                  let value = descObject["value"] {
            descriptionText = value
        } else {
            descriptionText = "No description available."
        }
    }

    var largeCoverURL: URL? {
        guard let id = covers?.first else { return nil }
        return URL(string: "https://covers.openlibrary.org/b/id/\(id)-L.jpg")
    }
}

