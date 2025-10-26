//
//  BookmarksView.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 25/10/25.
//

import SwiftUI
import SwiftData

struct BookmarksView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \BookBookmark.createdAt, order: .reverse) private var bookmarks: [BookBookmark]

    var body: some View {
        List {
            ForEach(bookmarks) { b in
                NavigationLink {
                    BookDetailOfflineView(bookmark: b)
                } label: {
                    HStack(alignment: .top, spacing: 12) {
                        if let url = b.coverURL {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 75)
                                        .cornerRadius(6)
                                default:
                                    Color.gray.frame(width: 50, height: 75).cornerRadius(6)
                                }
                            }
                        } else {
                            Color.gray.frame(width: 50, height: 75).cornerRadius(6)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text(b.title)
                                .font(.headline)
                                .lineLimit(2)
                            if let authors = b.authorNames, !authors.isEmpty {
                                Text(authors.joined(separator: ", "))
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                            }
                            if let desc = b.descriptionText {
                                Text(desc)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .lineLimit(2)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
                .swipeActions {
                    Button(role: .destructive) {
                        context.delete(b)
                        try? context.save()
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
        .navigationTitle("Bookmarks")
    }
}
