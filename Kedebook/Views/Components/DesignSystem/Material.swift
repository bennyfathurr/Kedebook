//
//  Material.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 26/10/25.
//

import SwiftUI

struct KdMaterial: ViewModifier {
    func body(content: Content) -> some View {
        Group {
            if #available(iOS 26, *) {
                content
                    .background(.regularMaterial) // tinted liquid glass
            } else {
                content
                    .background(KdColor.surfaceCard)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: KdRadius.card.rawValue, style: .continuous))
    }
}

extension View {
    func kdMaterialCard() -> some View { self.modifier(KdMaterial()) }
}
