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
    @Attribute(.unique) var userID: UUID
    var name: String
    var email: String?
    var avatarURLString: String?

    init(name: String, /*email: String? = nil,*/ avatarURL: URL? = nil) {
        self.userID = UUID()
        self.name = name
        //self.email = email
        self.avatarURLString = avatarURL?.absoluteString
    }

    var avatarURL: URL? { avatarURLString.flatMap(URL.init(string:)) }
}
