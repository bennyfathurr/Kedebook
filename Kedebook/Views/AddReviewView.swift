//
//  AddReviewView.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 25/10/25.
//

import SwiftUI
import SwiftData

struct AddReviewView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Query private var profiles: [UserProfile]
    @ObservedObject var viewModel: BookDetailViewModel

    @State private var rating: Int = 3
    @State private var comment: String = ""
    @State private var showProfileAlert = false
    @State private var showDuplicateAlert = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Your Rating") {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Stars")
                                .font(.headline)
                            Spacer()
                            KdRatingStars(rating: rating)
                        }
                        Stepper("Set Rating: \(rating)", value: $rating, in: 1...5)
                    }
                }

                Section("Your Comment") {
                    TextEditor(text: $comment)
                        .frame(minHeight: 120)
                        .scrollContentBackground(.hidden)
                        .background(Color(uiColor: .secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                Section {
                    Button {
                        Task { await submitReview() }
                    } label: {
                        Text("Submit")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .background(Color(red: 0.85, green: 0.33, blue: 0.28))
                            .cornerRadius(10)
                    }
                }
            }
            .navigationTitle("Write Review")
            .alert("Profile Required", isPresented: $showProfileAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Please create your profile before writing a review.")
            }
            .alert("Duplicate Review", isPresented: $showDuplicateAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("You’ve already posted a review for this book.")
            }
        }
    }

    // MARK: - Review Logic
    private func submitReview() async {
        guard let profile = profiles.first else {
            showProfileAlert = true
            return
        }

        let username = profile.name.isEmpty ? "Anonymous" : profile.name

        // Local save
        let entity = ReviewEntity(
            bookID: viewModel.workKey,
            user: username,
            rating: rating,
            comment: comment
        )
        LocalStore.shared.save(entity, context: context)

        // Remote sync
        let remote = Review(
            id: nil,
            book_id: viewModel.workKey,
            user: username,
            rating: rating,
            comment: comment,
            created_at: nil,
            device_id: DeviceIdentity.shared.id
        )

        if NetworkMonitor.shared.isConnected {
            do {
                try await viewModel.reviewService.postReview(remote)
                LocalStore.shared.markSynced(entity.localID, context: context)
            } catch {
                showDuplicateAlert = true
                print("Failed to post review:", error.localizedDescription)
            }
        }

        await viewModel.refreshReviews()
        dismiss()
    }
}
