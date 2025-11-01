//
//  ColorTokens.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 26/10/25.
//

import SwiftUI

enum KdColor {
    static let accent       = Color("PrimaryAccent")
    static let background   = Color("BackgroundMain")
    static var surfaceCard: Color {
        if #available(iOS 26, *) {
            return Color.white.opacity(0.9)
        } else {
            return Color("SurfaceCard")
        }
    }
    static let textPrimary  = Color("TextPrimary")
    static let textSecondary = Color("TextSecondary")
    static let iconInactive = Color("IconInactive")
    static let divider      = Color("Divider")
}
