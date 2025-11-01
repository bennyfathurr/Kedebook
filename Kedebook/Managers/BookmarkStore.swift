//
//  BookmarkStore.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 25/10/25.
//

import SwiftData
import Foundation

@MainActor
final class BookmarkStore {
    static let shared = BookmarkStore()
    private init() {}

    func isBookBookmarked(_ bookID: String, context: ModelContext) -> Bool {
        let d = FetchDescriptor<BookBookmark>(
            predicate: #Predicate { $0.bookID == bookID }
        )
        return ((try? context.fetch(d)) ?? []).isEmpty == false
    }

    func addBookmark(bookID: String, title: String, coverURL: URL?, authors: [String]? = nil, description: String? = nil, context: ModelContext) {
        let bookmark = BookBookmark(bookID: bookID, title: title, coverURL: coverURL, authors: authors, description: description)
        context.insert(bookmark)
        try? context.save()
    }


    func removeBookmark(bookID: String, context: ModelContext) {
        let d = FetchDescriptor<BookBookmark>(
            predicate: #Predicate { $0.bookID == bookID }
        )
        let matches = (try? context.fetch(d)) ?? []
        for b in matches { context.delete(b) }
        try? context.save()
    }

    func allBookmarks(context: ModelContext) -> [BookBookmark] {
        let d = FetchDescriptor<BookBookmark>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        return (try? context.fetch(d)) ?? []
    }
}

extension BookmarkStore {
    func isBookmarked(bookID: String, context: ModelContext) -> Bool {
        let request = FetchDescriptor<BookBookmark>(
            predicate: #Predicate { $0.bookID == bookID }
        )
        return (try? context.fetch(request).isEmpty == false) ?? false
    }
}
