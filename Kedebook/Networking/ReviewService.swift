//
//  ReviewService.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 25/10/25.
//

import Foundation
import Supabase

// MARK: - Review Model
struct Review: Identifiable, Codable {
    var id: UUID?
    let book_id: String
    let user: String
    let rating: Int
    let comment: String
    let created_at: String?
    var device_id: String
}

// MARK: - ReviewService (Supabase)
final class ReviewService {
    static let shared = ReviewService()
    private let client: SupabaseClient

    init(client: SupabaseClient = SupabaseClientManager.shared.client) {
        self.client = client
    }

    // MARK: Fetch all reviews for a specific book
    func fetchReviews(bookID: String) async throws -> [Review] {
        return try await client
            .database
            .from("reviews")
            .select()
            .eq("book_id", value: bookID)
            .order("created_at", ascending: false)
            .execute()
            .value
    }

    // MARK: Post a new review (without returning)
    func postReview(_ review: Review) async throws {
        var updatedReview = review
        updatedReview.device_id = DeviceIdentity.shared.id
        try await client
            .database
            .from("reviews")
            .insert(updatedReview)
            .execute()
    }

    // MARK: Post + return inserted row(s)
    func postReviewAndReturn(_ review: Review) async throws -> [Review] {
        return try await client
            .database
            .from("reviews")
            .insert(review)
            .select()
            .execute()
            .value
    }

    // MARK: Fetch average rating for a specific book
    func averageRating(bookID: String) async throws -> Double {
        do {
            // Example using PostgREST aggregate; adapt to your Supabase Swift API
            // SELECT avg(rating) FROM reviews WHERE book_id = :id;
            struct AvgRow: Decodable { let avg: Double? }
            let row: AvgRow = try await client
                .database
                .from("reviews")
                .select("avg(rating)", head: false, count: .none)
                .eq("book_id", value: bookID)
                .single()
                .execute()
                .value
            return row.avg ?? 0.0
        } catch is CancellationError {
            // expected when the view refreshes / sheet opens; do not log or rethrow
            return 0.0
        }
    }
}
