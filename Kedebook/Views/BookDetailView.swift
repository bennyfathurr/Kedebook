//
//  BookDetailView.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 25/10/25.
//

import SwiftUI

struct BookDetailView: View {
    let book: Book
    @Environment(\.modelContext) private var context
    @State private var isBookmarked = false
    @StateObject private var viewModel: BookDetailViewModel
    @State private var showingAddReview = false
    
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
            VStack(alignment: .leading) {
                if let url = viewModel.largeCoverURL {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(height: 200)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                        case .failure:
                            Image(systemName: "book.closed")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
                
                Text(viewModel.title)
                    .font(.title)
                    .padding(.vertical, 4)
                
                Text("By " + viewModel.authors.joined(separator: ", "))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Divider()
                    .padding(.vertical, 8)
                
                Text(viewModel.description)
                    .padding(.bottom, 16)
                
                
                Section("User Reviews") {
                    if viewModel.reviews.isEmpty {
                        Text("No reviews yet.")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(viewModel.reviews) { review in
                            VStack(alignment: .leading, spacing: 4) {
                                Text("⭐️ \(review.rating) / 5")
                                    .bold()
                                Text(review.comment)
                            }
                            .padding(.vertical, 6)
                        }
                    }
                }
                
            }
            .padding()
        }
        .toolbar {
            Button("Add Review") {
                showingAddReview = true
            }
            Button(isBookmarked ? "Remove Bookmark" : "Bookmark") {
                if isBookmarked {
                    BookmarkStore.shared.removeBookmark(bookID: book.id, context: context)
                    isBookmarked = false
                } else {
                    BookmarkStore.shared.addBookmark(
                        bookID: book.id,
                        title: book.title,
                        coverURL: book.coverURL(size: .medium),
                        authors: viewModel.authors,
                        description: viewModel.description,
                        context: context
                    )

                    isBookmarked = true
                }
            }
        }
        .sheet(isPresented: $showingAddReview) {
            AddReviewView(viewModel: viewModel)
        }
        .onAppear {
            isBookmarked = BookmarkStore.shared.isBookBookmarked(book.id, context: context)
        }
        .navigationTitle(viewModel.title.isEmpty ? "Details" : viewModel.title)
        .onAppear {
            Task { await viewModel.fetchDetails() }
        }
    }
}
