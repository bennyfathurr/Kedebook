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
    @Query(sort: \BookBookmark.createdAt, order: .reverse)
    var bookmarks: [BookBookmark]

    var body: some View {
        NavigationStack {
            if bookmarks.isEmpty {
                emptyState
            } else {
                bookmarkList
            }
        }
        .background(KdColor.background.ignoresSafeArea())
        .navigationTitle("Bookmarks")
    }

    private var emptyState: some View {
        Text("No bookmarks yet.")
            .font(KdFont.body)
            .foregroundStyle(KdColor.textSecondary)
    }

    private var bookmarkList: some View {
        ScrollView {
            LazyVStack(spacing: KdSpace.md) {
                ForEach(bookmarks) { b in
                    BookmarkRow(bookmark: b)
                }
            }
            .padding(KdSpace.md)
        }
    }
}

private struct BookmarkRow: View {
    let bookmark: BookBookmark

    var body: some View {
        NavigationLink(destination: BookDetailOfflineView(bookmark: bookmark)) {
            HStack(spacing: KdSpace.md) {
                AsyncImage(url: bookmark.coverURL) { phase in
                    switch phase {
                    case .success(let img): img.resizable().scaledToFill()
                    default: Rectangle().fill(KdColor.divider.opacity(0.3))
                    }
                }
                .frame(width: 80, height: 110)
                .clipShape(RoundedRectangle(cornerRadius: KdRadius.card))

                VStack(alignment: .leading, spacing: 4) {
                    Text(bookmark.title)
                        .font(KdFont.body.weight(.semibold))
                        .foregroundStyle(KdColor.textPrimary)
                        .lineLimit(2)
                    if let authors = bookmark.authorNames, !authors.isEmpty {
                        Text(authors.joined(separator: ", "))
                            .font(KdFont.caption)
                            .foregroundStyle(KdColor.textSecondary)
                            .lineLimit(1)
                    }
                    if let desc = bookmark.descriptionText {
                        Text(desc)
                            .font(KdFont.caption)
                            .foregroundStyle(KdColor.textSecondary)
                            .lineLimit(2)
                    }
                }
                Spacer()
            }
            .padding(KdSpace.md)
            .kdCard()
        }
        .buttonStyle(.plain)
    }
}
