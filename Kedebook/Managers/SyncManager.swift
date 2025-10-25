//
//  SyncManager.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 25/10/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class SyncManager: ObservableObject {
    static let shared = SyncManager()
    private let local = LocalStore.shared
    private let reviewService = ReviewService()
    
    private init() {}
    
    @Published var isSyncing: Bool = false

    func syncPending() async {
        guard NetworkMonitor.shared.isConnected else { return }

        let pending = local.pendingReviews()
        guard !pending.isEmpty else { return }

        isSyncing = true
        defer { isSyncing = false }

        for review in pending {
            do {
                // Include device_id so the backend knows which device owns this review
                let remote = Review(
                    id: nil,
                    book_id: review.bookID,
                    user: review.user,
                    rating: review.rating,
                    comment: review.comment,
                    created_at: nil,
                    device_id: DeviceIdentity.shared.id
                )

                try await reviewService.postReview(remote)
                local.markSynced(review.localID)
                print("Synced review \(review.localID)")
            } catch {
                let message = error.localizedDescription.lowercased()
                if message.contains("duplicate key") || message.contains("unique constraint") {
                    print("Duplicate review detected — already synced earlier.")
                    local.markSynced(review.localID)
                } else {
                    print("Failed to sync review \(review.localID): \(error)")
                }
            }
        }
    }
}
