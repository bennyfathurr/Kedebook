//
//  BookDetailViewModel.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 25/10/25.
//

import Foundation
import Combine

@MainActor
final class BookDetailViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var authors: [String] = []
    @Published var description: String = "Loading…"
    @Published var largeCoverURL: URL?

    private let service = BookService()
    private let authorService = AuthorService()
    let workKey: String
    private let fallbackAuthors: [String]
    
    @Published var reviews: [Review] = []
    let reviewService = ReviewService()


    init(workKey: String, fallbackAuthors: [String]) {
        self.workKey = workKey
        self.fallbackAuthors = fallbackAuthors
        self.authors = fallbackAuthors // immediate display
    }

    func fetchDetails() async {
        // 1) Cache hit for book detail
        if let cached = await CacheManager.shared.getBookDetail(forKey: workKey) {
            apply(detail: cached)
            // Resolve authors using keys from cached detail
            await resolveAuthors(from: cached)
            return
        }

        // 2) Network fetch for book detail
        do {
            let detail = try await service.getBookDetails(workKey: workKey)
            await CacheManager.shared.setBookDetail(detail, forKey: workKey)
            apply(detail: detail)
            await resolveAuthors(from: detail)
        } catch {
            self.description = "Failed to load details: \(error.localizedDescription)"
        }
        
        do { self.reviews = try await reviewService.fetchReviews(bookID: workKey) }
        catch { print("⚠️ No reviews yet or failed: \(error)") }

    }

    private func apply(detail: BookDetail) {
        self.title = detail.title
        self.description = detail.descriptionText
        self.largeCoverURL = detail.largeCoverURL
    }

    private func extractAuthorKeys(from detail: BookDetail) -> [String] {
        detail.authors?.map { $0.author.key } ?? []
    }

    private func nonEmptyUnique(_ xs: [String]) -> [String] {
        Array(Set(xs)).filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    }

    private func mergeAuthors(fetched: [String]) -> [String] {
        // Prefer fetched names; fall back to search authors; deduplicate
        nonEmptyUnique(fetched.isEmpty ? fallbackAuthors : fetched)
    }

    private func cachedNames(for keys: [String]) async -> ([String], [String]) {
        // returns (hitNames, missKeys)
        let hitsOptional = await CacheManager.shared.getAuthorNames(for: keys)
        var hits: [String] = []
        var misses: [String] = []
        for (idx, maybe) in hitsOptional.enumerated() {
            if let n = maybe { hits.append(n) } else { misses.append(keys[idx]) }
        }
        return (hits, misses)
    }

    private func cache(names: [String], for keys: [String]) async {
        guard names.count == keys.count else { return }
        let dict = Dictionary(uniqueKeysWithValues: zip(keys, names))
        await CacheManager.shared.setAuthorNames(dict)
    }

    private func setAuthorsSafely(_ names: [String]) {
        let merged = mergeAuthors(fetched: names)
        if !merged.isEmpty { self.authors = merged }
    }

    private func resolveAuthors(from detail: BookDetail) async {
        let keys = extractAuthorKeys(from: detail)
        guard !keys.isEmpty else {
            setAuthorsSafely([])
            return
        }

        // 1) Read from cache
        let (hitNames, missKeys) = await cachedNames(for: keys)
        var resolved = hitNames

        // 2) Fetch misses concurrently
        if !missKeys.isEmpty {
            let fetched = await authorService.fetchNames(for: missKeys)
            resolved.append(contentsOf: fetched)
            await cache(names: fetched, for: Array(missKeys.prefix(fetched.count)))
        }

        // 3) Apply to UI (fallback if needed)
        setAuthorsSafely(resolved)
    }
    
    func refreshReviews() async {
        do { self.reviews = try await reviewService.fetchReviews(bookID: workKey) }
        catch { print("⚠️ \(error)") }
    }

}
