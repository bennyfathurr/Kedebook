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
        List(bookmarks) { b in
            HStack {
                if let url = b.coverURL {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image.resizable().frame(width: 40, height: 60).cornerRadius(4)
                        default:
                            Color.gray.frame(width: 40, height: 60).cornerRadius(4)
                        }
                    }
                } else {
                    Color.gray.frame(width: 40, height: 60).cornerRadius(4)
                }
                Text(b.title).font(.headline)
            }
            .swipeActions {
                Button(role: .destructive) {
                    context.delete(b)
                    try? context.save()
                } label: { Text("Delete") }
            }
        }
        .navigationTitle("Bookmarks")
    }
}
