//
//  RootView.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 25/10/25.
//

import SwiftUI

struct RootView: View {
    @Environment(\.modelContext) private var context
    
    var body: some View {
        TabView {
            NavigationStack { BookListView() }
                .tabItem { Label("Search", systemImage: "book") }

            NavigationStack { BookmarksView() }
                .tabItem { Label("Bookmarks", systemImage: "bookmark") }

            NavigationStack { ProfileView() }
                .tabItem { Label("Profile", systemImage: "person.crop.circle") }
        }
        .task {
                await SyncManager.shared.syncPending(context: context)
              }
    }
}
