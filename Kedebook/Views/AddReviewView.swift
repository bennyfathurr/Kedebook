//
//  AddReviewView.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 25/10/25.
//

import SwiftUI

struct AddReviewView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @ObservedObject var viewModel: BookDetailViewModel
    @State private var comment = ""
    @State private var rating = 3

    var body: some View {
        Form {
            Section(header: Text("Your Review")) {
                Stepper("Rating: \(rating)", value: $rating, in: 1...5)
                TextField("Comment", text: $comment)
            }

            Button("Submit") {
                Task {
                    // 1. Create local entity (for offline cache)
                    let entity = ReviewEntity(
                        bookID: viewModel.workKey,
                        user: "Benz",
                        rating: rating,
                        comment: comment
                    )

                    LocalStore.shared.save(entity, context: context)

                    // 2. Build review payload with device UUID
                    let remoteReview = Review(
                        id: nil,
                        book_id: viewModel.workKey,
                        user: "Benz",
                        rating: rating,
                        comment: comment,
                        created_at: nil,
                        device_id: DeviceIdentity.shared.id  // ← pseudonymous device id here
                    )

                    // 3. If online, send to Supabase
                    if NetworkMonitor.shared.isConnected {
                        do {
                            try await viewModel.reviewService.postReview(remoteReview)
                            LocalStore.shared.markSynced(entity.localID, context: context)
                            print("Review submitted successfully.")
                        } catch {
                            let message = error.localizedDescription.lowercased()
                            if message.contains("duplicate key") || message.contains("unique constraint") {
                                print("You’ve already posted a review for this book on this device.")
                            } else {
                                print("Failed to post review: \(error)")
                            }
                        }
                    } else {
                        print("📡 Offline: review saved locally and will sync later.")
                    }

                    // 4. Refresh local UI list
                    await viewModel.refreshReviews()
                    dismiss()
                }
            }
        }
    }
}
