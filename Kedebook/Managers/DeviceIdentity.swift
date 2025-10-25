//
//  DeviceIdentity.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 25/10/25.
//

import Foundation

final class DeviceIdentity {
    static let shared = DeviceIdentity()
    private let key = "device_uuid"
    
    private init() {}
    var id: String {
        if let existing = UserDefaults.standard.string(forKey: key) {
            return existing
        } else {
            let newID = UUID().uuidString
            UserDefaults.standard.set(newID, forKey: key)
            return newID
        }
    }
}
