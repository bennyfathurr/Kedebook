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
    var bookID: String          // e.g. "/works/OL45804W"
    var title: String
    var coverURLString: String? // store as String; build URL when needed
    var createdAt: Date

    init(bookID: String, title: String, coverURL: URL?) {
        self.id = UUID()
        self.bookID = bookID
        self.title = title
        self.coverURLString = coverURL?.absoluteString
        self.createdAt = Date()
    }

    var coverURL: URL? { coverURLString.flatMap(URL.init(string:)) }
}
