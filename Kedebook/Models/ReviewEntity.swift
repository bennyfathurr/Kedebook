//
//  ReviewEntity.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 25/10/25.
//

import SwiftData
import Foundation

@Model
final class ReviewEntity {
    @Attribute(.unique) var localID: UUID
    var bookID: String
    var user: String
    var rating: Int
    var comment: String
    var createdAt: Date
    var synced: Bool

    init(bookID: String, user: String, rating: Int, comment: String, synced: Bool = false) {
        self.localID = UUID()
        self.bookID = bookID
        self.user = user
        self.rating = rating
        self.comment = comment
        self.createdAt = Date()
        self.synced = synced
    }
}

