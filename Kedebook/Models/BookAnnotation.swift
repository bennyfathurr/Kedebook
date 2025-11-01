//
//  BookAnnotation.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 28/10/25.
//

import Foundation
import SwiftData

@Model
final class BookAnnotation {
    var id: UUID
    var page: String
    var note: String
    var date: Date

    init(page: String, note: String, date: Date) {
        self.id = UUID()
        self.page = page
        self.note = note
        self.date = date
    }
}
