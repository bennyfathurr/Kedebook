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
                    .background(.regularMaterial) // tinted liquid glass for iOS 26+
            } else {
                content
                    .background(KdColor.surfaceCard) // fallback solid surface
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: KdRadius.card, style: .continuous))
    }
}

extension View {
    func kdCard() -> some View {
        self
            .background(
                Group {
                    if #available(iOS 26, *) {
                        // Match iOS 26 liquid-glass white style
                        RoundedRectangle(cornerRadius: KdRadius.card, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.white,
                                        Color.white
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: KdRadius.card, style: .continuous)
                                    .stroke(Color.white.opacity(0.25), lineWidth: 0.5)
                            )
                            .shadow(color: .black.opacity(0.08), radius: 6, y: 3)
                            .compositingGroup() // isolate from material blending
                    } else {
                        // iOS 17–18 fallback: clean white card
                        RoundedRectangle(cornerRadius: KdRadius.card, style: .continuous)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.06), radius: 4, y: 2)
                    }
                }
            )
    }
}
