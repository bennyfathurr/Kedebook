//
//  KedebookApp.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 23/10/25.
//

import SwiftUI
import SwiftData

@main
struct KedebookApp: App {
    @StateObject private var syncManager = SyncManager.shared

    var body: some Scene {
        WindowGroup {
            RootView()
                .modelContainer(for: [ReviewEntity.self, BookBookmark.self, UserProfile.self])
                .onAppear { Task { await syncManager.syncPending() } }
        }
    }
}

