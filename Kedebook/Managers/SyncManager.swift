//
//  SyncManager.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 25/10/25.
//

import Foundation
import SwiftUI
import Combine
import SwiftData

@MainActor
final class SyncManager: ObservableObject {
    static let shared = SyncManager()
    private let reviewService = ReviewService()
    private init() {}

    func syncPending(context: ModelContext) async {
        guard NetworkMonitor.shared.isConnected else { return }
        let pending = LocalStore.shared.pendingReviews(context: context)

        for r in pending {
            do {
                let remote = Review(
                    id: nil,
                    book_id: r.bookID,
                    user: r.user,
                    rating: r.rating,
                    comment: r.comment,
                    created_at: nil,
                    device_id: DeviceIdentity.shared.id
                )
                try await reviewService.postReview(remote)
                LocalStore.shared.markSynced(r.localID, context: context)
            } catch {
                // handle duplicate -> mark synced to stop retry
                if error.localizedDescription.lowercased().contains("duplicate") {
                    LocalStore.shared.markSynced(r.localID, context: context)
                } else {
                    print("sync fail:", error)
                }
            }
        }
    }
}
