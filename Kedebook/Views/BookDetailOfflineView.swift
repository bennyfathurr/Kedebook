//
//  BookDetailOfflineView.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 25/10/25.
//

import SwiftUI

struct BookDetailOfflineView: View {
    let bookmark: BookBookmark
    @State private var bookDetail: BookDetail?
    @State private var isLoading = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: - Cover
                if let url = bookmark.coverURL {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                                .cornerRadius(8)
                        default:
                            Color.gray
                                .frame(height: 200)
                                .cornerRadius(8)
                        }
                    }
                }

                // MARK: - Title & Author
                Text(bookmark.title)
                    .font(.title2)
                    .bold()

                if let authors = bookmark.authorNames, !authors.isEmpty {
                    Text(authors.joined(separator: ", "))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Divider()

                // MARK: - Description
                if isLoading {
                    ProgressView("Loading description...")
                        .padding(.vertical, 8)
                } else {
                    Text(bookDetail?.descriptionText ?? "No description available.")
                        .font(.body)
                        .foregroundColor(.primary)
                        .lineSpacing(4)
                }
            }
            .padding()
        }
        .navigationTitle("Book Detail")
        .task {
            await fetchUpdatedDetailsIfNeeded()
        }
    }

    // MARK: - Fetch Details
    private func fetchUpdatedDetailsIfNeeded() async {
        guard bookDetail == nil else { return }
        isLoading = true
        defer { isLoading = false }

        let service = BookService()
        do {
            let detail = try await service.getBookDetails(workKey: bookmark.bookID)
            bookDetail = detail
        } catch {
            print("Failed to fetch book details: \(error)")
        }
    }
}
