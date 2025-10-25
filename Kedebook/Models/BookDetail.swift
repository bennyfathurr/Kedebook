//
//  BookDetail.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 25/10/25.
//

import Foundation

// MARK: - Detail Model
struct BookDetail: Decodable {
    let title: String
    let description: Description?
    let covers: [Int]?
    let authors: [AuthorRef]?

    struct Description: Decodable { let value: String? }
    struct AuthorRef: Decodable { let author: AuthorObject }
    struct AuthorObject: Decodable { let key: String }

    var largeCoverURL: URL? {
        guard let first = covers?.first else { return nil }
        return URL(string: "https://covers.openlibrary.org/b/id/\(first)-L.jpg")
    }

    var descriptionText: String {
        description?.value ?? "No description available."
    }
}
