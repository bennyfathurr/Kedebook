//
//  UserProfile.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 25/10/25.
//

import SwiftData
import Foundation

@Model
final class UserProfile {
    @Attribute(.unique) var userID: String
    var name: String
    //var email: String?
    @Attribute(originalName: "avatarURLString") var avatarPath: String?

    init(name: String, /*email: String? = nil,*/ avatarPath: String? = nil) {
        self.userID = DeviceIdentity.shared.id
        self.name = name
        //self.email = email
        self.avatarPath = avatarPath
    }

    var avatarImageURL: URL? {
        guard let path = avatarPath else { return nil }
        return URL(fileURLWithPath: path)
    }
}
