//
//  SearchView.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 26/10/25.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = BookListViewModel()
    @State private var query: String = ""

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading…")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color(.systemBackground))
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color(.systemBackground))
                } else if viewModel.books.isEmpty {
                    ContentUnavailableView(
                        "No Results",
                        systemImage: "book.closed",
                        description: Text("Try searching for a book title or author.")
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemBackground))
                } else {
                    ScrollView {
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: 16),
                                GridItem(.flexible(), spacing: 16)
                            ],
                            spacing: 24
                        ) {
                            ForEach(viewModel.books) { book in
                                NavigationLink(destination: BookDetailView(book: book)) {
                                    BookCard(
                                        coverURL: book.coverURL(size: .medium),
                                        title: book.title,
                                        author: book.author_name?.first ?? ""
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 16)
                    }
                    .background(Color(.systemBackground))
                }
            }
            .navigationTitle("Search")
            .searchable(text: $query, prompt: "Search for books or authors")
            .onSubmit(of: .search) {
                Task { await viewModel.search(query: query) }
            }
            .onChange(of: query) { newValue in
                // Optional live search behavior
                if newValue.count > 3 {
                    Task { await viewModel.search(query: newValue) }
                }
            }
//            .toolbar {
//                ToolbarItem(placement: .principal) {
//                    Text("Search")
//                        .font(.headline)
//                        .accessibilityAddTraits(.isHeader)
//                }
//            }
//            .background(Color(.systemBackground))
        }
    }
}

