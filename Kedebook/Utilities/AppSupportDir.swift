//
//  AppSupportDir.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 28/10/25.
//

import Foundation

enum AppSupportDir {
    static func ensureExists() {
        let fm = FileManager.default
        var url = fm.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        if !fm.fileExists(atPath: url.path) {
            do {
                try fm.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch {
                // Log so you can see problems on-device
                print("Failed to create Application Support dir:", error)
            }
        }
        // Optional: exclude from iCloud backup
        var vals = URLResourceValues()
        vals.isExcludedFromBackup = true
        try? url.setResourceValues(vals)
    }
}
