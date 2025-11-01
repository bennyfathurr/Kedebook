//
//  BookListViewModel.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 25/10/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class BookListViewModel: ObservableObject {
    @Published var query: String = ""
    @Published var books: [Book] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var ratings: [String: Double] = [:]

    private let service = BookService()
    private let reviewService = ReviewService() // ✅ real instance

    // MARK: - Load initial books
    func loadInitialBooks() async {
        isLoading = true
        defer { isLoading = false }

        do {
            books = try await service.fetchPopularBooks()
            await loadRatings(for: books)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Search books
    func search(query: String) async {
        isLoading = true
        defer { isLoading = false }

        do {
            books = try await service.searchBooks(query: query)
            await loadRatings(for: books)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Filter by category
    func filterByCategory(_ category: String?) async {
        guard let category, !category.isEmpty else {
            await loadInitialBooks()
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            books = try await service.fetchByCategory(category)
            await loadRatings(for: books)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Ratings
    private func loadRatings(for books: [Book]) async {
        for book in books {
            do {
                let avg = try await calculateAverageRating(for: book.id)
                await MainActor.run {
                    self.ratings[book.id] = avg
                }
            } catch is CancellationError {
                // ignore cancellations
            } catch {
                print("Failed to fetch rating for \(book.title): \(error)")
            }
        }
    }

    func averageRating(for bookID: String) -> Double {
        ratings[bookID] ?? 0.0
    }

    var featuredBooks: [Book] {
        Array(books.prefix(5))
    }

    // MARK: - Average rating calculator
    private func calculateAverageRating(for bookID: String) async throws -> Double {
        do {
            let reviews = try await reviewService.fetchReviews(bookID: bookID)
            guard !reviews.isEmpty else { return 0.0 }

            let sum = reviews.map { Double($0.rating) }.reduce(0, +)
            return sum / Double(reviews.count)
        } catch is CancellationError {
            throw CancellationError()
        } catch {
            throw error
        }
    }
}


extension BookService {
    // MARK: - Subject Response (popular / category)
    private struct SubjectResponse: Decodable {
        let works: [SubjectWork]
    }

    private struct SubjectWork: Decodable {
        let key: String
        let title: String
        let authors: [Author]?
        let cover_id: Int?

        struct Author: Decodable { let name: String }

        func toBook() -> Book {
            Book(
                id: key,
                title: title,
                author_name: authors?.map { $0.name },
                cover_i: cover_id
            )
        }
    }

    // MARK: - Fetch popular books
    func fetchPopularBooks() async throws -> [Book] {
        let urlString = "https://openlibrary.org/subjects/popular.json?limit=20"
        let response: SubjectResponse = try await APIClient.shared.get(
            urlString: urlString,
            responseType: SubjectResponse.self
        )
        return response.works.map { $0.toBook() }
    }

    // MARK: - Fetch by category (subject)
    func fetchByCategory(_ category: String) async throws -> [Book] {
        let subject = category.lowercased().replacingOccurrences(of: " ", with: "_")
        let urlString = "https://openlibrary.org/subjects/\(subject).json?limit=20"
        let response: SubjectResponse = try await APIClient.shared.get(
            urlString: urlString,
            responseType: SubjectResponse.self
        )
        return response.works.map { $0.toBook() }
    }
}
