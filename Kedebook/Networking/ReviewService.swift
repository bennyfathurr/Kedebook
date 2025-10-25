//
//  ReviewService.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 25/10/25.
//

import Foundation
import Supabase

struct Review: Identifiable, Codable {
    var id: UUID?
    let book_id: String
    let user: String
    let rating: Int
    let comment: String
    let created_at: String?
    var device_id: String
}


final class ReviewService {
    private let client: SupabaseClient

    init(client: SupabaseClient = SupabaseClientManager.shared.client) {
        self.client = client
    }

    // Fetch reviews for a specific book
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
    
    func postReview(_ review: Review) async throws {
        var updatedReview = review
        updatedReview.device_id = DeviceIdentity.shared.id
        try await client
            .database
            .from("reviews")
            .insert(updatedReview)
            .execute()
    }


    func postReviewAndReturn(_ review: Review) async throws -> [Review] {
        return try await client
            .database
            .from("reviews")
            .insert(review)
            .select()
            .execute()
            .value
    }
}
