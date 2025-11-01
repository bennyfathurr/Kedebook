//
//  BookListView.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 25/10/25.
//

import SwiftUI

struct BookListView: View {
    @StateObject private var viewModel = BookListViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Search books...", text: $viewModel.query)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    Button("Search") {
                        Task {
                            await viewModel.search(query: viewModel.query)
                        }
                    }
                    .padding(.trailing)
                }
                
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .padding()
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    List(viewModel.books) { book in
                        NavigationLink(destination: BookDetailView(book: book)) {
                            HStack {
                                if let cover = book.cover_i {
                                    AsyncImage(url: URL(string: "https://covers.openlibrary.org/b/id/\(cover)-S.jpg")) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .frame(width: 40, height: 60)
                                                .cornerRadius(4)
                                        case .failure:
                                            Image(systemName: "book.closed")
                                                .frame(width: 40, height: 60)
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                } else {
                                    Image(systemName: "book.closed")
                                        .frame(width: 40, height: 60)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text(book.title)
                                        .font(.headline)
                                    Text(book.author_name?.first ?? "Unknown Author")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Book Search")
        }
    }
}

