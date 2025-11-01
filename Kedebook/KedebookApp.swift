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
    
    init() {
            AppSupportDir.ensureExists()
        }

    var body: some Scene {
        WindowGroup {
            RootView()
                .modelContainer(for: [ReviewEntity.self, BookBookmark.self, UserProfile.self])
                .onAppear {
                    let storeURL = try? FileManager.default
                        .urls(for: .applicationSupportDirectory, in: .userDomainMask)
                        .first?.appendingPathComponent("default.store")
                    print("SwiftData store:", storeURL?.path ?? "unknown")
                    if let supportURL = try? FileManager.default
                        .urls(for: .applicationSupportDirectory, in: .userDomainMask)
                        .first?
                        .appendingPathComponent("default.store") {
                        print("SwiftData store location:", supportURL.path)
                    } else {
                        print("Could not locate SwiftData store.")
                    }
                }
        }
    }
}

