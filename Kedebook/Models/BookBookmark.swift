//
//  BookBookmark.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 25/10/25.
//

import SwiftData
import Foundation

@Model
final class BookBookmark {
    @Attribute(.unique) var id: UUID
    var bookID: String
    var title: String
    var coverURLString: String?
    var authorNames: [String]?
    var descriptionText: String?
    @Attribute(originalName: "dateAdded") var createdAt: Date

    init(bookID: String, title: String, coverURL: URL?, authors: [String]? = nil, description: String? = nil) {
        self.id = UUID()
        self.bookID = bookID
        self.title = title
        self.coverURLString = coverURL?.absoluteString
        self.authorNames = authors
        self.descriptionText = description
        self.createdAt = Date()
    }

    var coverURL: URL? { coverURLString.flatMap(URL.init(string:)) }
}

