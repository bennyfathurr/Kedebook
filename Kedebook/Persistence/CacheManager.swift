//
//  CacheManager.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 25/10/25.
//

import Foundation

actor CacheManager {
    static let shared = CacheManager()
    private init() {}

    // Cache for book details
    private var bookDetailCache: [String: BookDetail] = [:]

    func getBookDetail(forKey key: String) -> BookDetail? {
        bookDetailCache[key]
    }

    func setBookDetail(_ detail: BookDetail, forKey key: String) {
        bookDetailCache[key] = detail
    }

    // Cache for author names
    private var authorNameCache: [String: String] = [:]

    func getAuthorName(forKey key: String) -> String? {
        authorNameCache[key]
    }

    func setAuthorName(_ name: String, forKey key: String) {
        authorNameCache[key] = name
    }

    func getAuthorNames(for keys: [String]) -> [String?] {
        keys.map { authorNameCache[$0] }
    }

    func setAuthorNames(_ namesByKey: [String: String]) {
        for (k, v) in namesByKey {
            authorNameCache[k] = v
        }
    }
}
