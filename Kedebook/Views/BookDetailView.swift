//
//  BookDetailView.swift
//  Kedebook
//

import SwiftUI
import SwiftData

struct BookDetailView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @StateObject private var viewModel: BookDetailViewModel
    @State private var showReviewSheet = false
    @State private var isBookmarked = false
    @State private var showAlreadyReviewedAlert = false

    private let book: Book

    // MARK: Init
    init(book: Book) {
        self.book = book
        _viewModel = StateObject(
            wrappedValue: BookDetailViewModel(
                workKey: book.id,
                fallbackAuthors: book.author_name ?? []
            )
        )
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Cover
                AsyncImage(url: book.coverURL(size: .large)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 220)
                            .clipShape(RoundedRectangle(cornerRadius: KdRadius.card))
                            .shadow(radius: 4)
                    default:
                        RoundedRectangle(cornerRadius: KdRadius.card)
                            .fill(KdColor.divider.opacity(0.3))
                            .frame(width: 220, height: 320)
                    }
                }

                // Title + Authors
                VStack(spacing: 8) {
                    Text(viewModel.title.isEmpty ? book.title : viewModel.title)
                        .font(KdFont.h2)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.textTritary)
                        .padding(.horizontal)

                    if !viewModel.authors.isEmpty {
                        Text(viewModel.authors.joined(separator: ", "))
                            .font(KdFont.caption)
                            .foregroundStyle(Color.textTritary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                }

                // Description
                Text(viewModel.description)
                    .font(KdFont.body)
                    .foregroundStyle(Color.textTritary)
                    .padding(.horizontal)

                Divider().padding(.horizontal)

                // Reviews
                VStack(alignment: .leading, spacing: 12) {
                    Text("Reviews")
                        .font(KdFont.h3)
                        .foregroundStyle(KdColor.textPrimary)
                        .padding(.horizontal)

                    if viewModel.reviews.isEmpty {
                        Text("No reviews yet. Be the first to write one!")
                            .font(KdFont.caption)
                            .foregroundStyle(KdColor.textSecondary)
                            .padding(.horizontal)
                    } else {
                        ForEach(viewModel.reviews) { review in
                            ReviewRow(review: review)
                                .padding(.horizontal)
                        }
                    }
                }
                .padding(.bottom, 40)
            }
            .padding(.top)
        }
        .background(KdColor.background.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                // Write review — present instantly, don’t await first
                Button {
                    if hasReviewedOnThisDevice(bookID: viewModel.workKey) {
                        showAlreadyReviewedAlert = true
                    } else {
                        showReviewSheet = true
                    }
                } label: {
                    Image(systemName: "square.and.pencil").font(.headline)
                }

                // Bookmark toggle
                Button {
                    if isBookmarked {
                        BookmarkStore.shared.removeBookmark(bookID: viewModel.workKey, context: context)
                        isBookmarked = false
                    } else {
                        BookmarkStore.shared.addBookmark(
                            bookID: viewModel.workKey,
                            title: viewModel.title.isEmpty ? book.title : viewModel.title,
                            coverURL: book.coverURL(size: .medium),
                            authors: viewModel.authors.isEmpty ? book.author_name : viewModel.authors,
                            description: viewModel.description,
                            context: context
                        )
                        isBookmarked = true
                    }
                } label: {
                    Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                        .font(.headline)
                }
                .accessibilityLabel(isBookmarked ? "Remove Bookmark" : "Add Bookmark")
            }
        }
        // Hide bottom tab bar on this screen
        .toolbar(.hidden, for: .tabBar)

        // Full-height sheet for writing a review
        .sheet(isPresented: $showReviewSheet, onDismiss: {
            Task { await viewModel.refreshReviews() }
        }) {
            NavigationStack {
                AddReviewView(viewModel: viewModel)
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
                    .interactiveDismissDisabled(false)
            }
        }

        // Duplicate review alert
        .alert("Review Already Submitted", isPresented: $showAlreadyReviewedAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("You’ve already submitted a review for this book on this device.")
        }

        // Initial loads
        .task {
            // set current bookmark state
            isBookmarked = BookmarkStore.shared.isBookmarked(bookID: viewModel.workKey, context: context)
            await viewModel.fetchDetails()
        }
    }

    // MARK: Per-device duplicate guard
    private func hasReviewedOnThisDevice(bookID: String) -> Bool {
        UserDefaults.standard.bool(forKey: "reviewed.\(bookID)")
    }
}

// MARK: - Review Row
private struct ReviewRow: View {
    let review: Review

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: "person.circle.fill")
                    .font(.title3)
                    .foregroundStyle(KdColor.textSecondary)

                Text(review.user)
                    .font(KdFont.body.weight(.semibold))

                Spacer()

                Text(formattedDate(from: review.created_at))
                    .font(KdFont.caption)
                    .foregroundStyle(KdColor.textSecondary)
            }

            HStack(spacing: 2) {
                ForEach(0..<5, id: \.self) { i in
                    Image(systemName: i < review.rating ? "star.fill" : "star")
                        .foregroundStyle(i < review.rating ? KdColor.accent : KdColor.divider)
                        .font(.caption)
                }
            }

            Text(review.comment)
                .font(KdFont.body)
                .foregroundStyle(KdColor.textPrimary)
                .padding(.top, 2)
        }
        .padding()
        .kdCard()
    }
}

// MARK: - Date formatting (ISO8601 → readable)
private func formattedDate(from timestamp: String?) -> String {
    guard let timestamp else { return "Unknown date" }

    let iso = ISO8601DateFormatter()
    iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

    let date: Date? = iso.date(from: timestamp)
        ?? ISO8601DateFormatter().date(from: timestamp) // fallback without fractional seconds

    guard let d = date else { return timestamp }

    let fmt = DateFormatter()
    fmt.locale = .current
    fmt.dateStyle = .medium
    fmt.timeStyle = .short
    return fmt.string(from: d) // e.g., “Oct 26, 2025 at 8:18 AM”
}
