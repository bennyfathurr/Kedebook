//
//  ProfileStore.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 25/10/25.
//

import SwiftData
import Foundation

@MainActor
final class ProfileStore {
    static let shared = ProfileStore()
    private init() {}

    func getOrCreateProfile(context: ModelContext) -> UserProfile {
        let d = FetchDescriptor<UserProfile>()
        if let existing = try? context.fetch(d), let first = existing.first { return first }
        let p = UserProfile(name: "Benz")
        context.insert(p)
        try? context.save()
        return p
    }

    func updateProfile(_ profile: UserProfile, name: String, /*email: String?,*/ avatarURL: URL?, context: ModelContext) {
        profile.name = name
        //profile.email = email
        //profile.avatarURLString = avatarURL?.absoluteString
        try? context.save()
    }
}
