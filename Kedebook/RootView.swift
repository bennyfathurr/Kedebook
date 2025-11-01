//
//  RootView.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 25/10/25.
//

import SwiftUI
import SwiftData

struct RootView: View {
    @Environment(\.modelContext) private var context
    @State private var tab: KdTab = .home
    
    var body: some View {
        TabView(selection: $tab) {
            NavigationStack { LibraryView() }
                .tabItem { Label("Home", systemImage: "house") }
                .tag(KdTab.home)

            NavigationStack { SearchView() }
                .tabItem { Label("Search", systemImage: "magnifyingglass") }
                .tag(KdTab.search)
            
            NavigationStack { AnnotationView() }
                .tabItem { Label("Annotation", systemImage: "highlighter") }
                .tag(KdTab.profile)

            NavigationStack { BookmarksView() }
                .tabItem { Label("Library", systemImage: "books.vertical") }
                .tag(KdTab.library)
        }
        .tint(KdColor.accent)
        .background(KdColor.background.ignoresSafeArea())
        .task { await SyncManager.shared.syncPending(context: context) }
    }
}


private struct WriteReviewViewStub: View {
    var body: some View {
        Text("Quick Review Access").font(KdFont.h2)
            .foregroundStyle(KdColor.textSecondary)
    }
}


#Preview {
    RootView()
        .modelContainer(for: [BookBookmark.self])   // if you use SwiftData
}

