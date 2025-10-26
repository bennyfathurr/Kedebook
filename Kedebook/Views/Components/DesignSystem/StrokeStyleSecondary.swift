//
//  StrokeStyleSecondary.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 26/10/25.
//

import SwiftUI

struct KdSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(KdFont.body.weight(.semibold))
            .foregroundStyle(KdColor.accent)
            .padding(.vertical, KdSpace.md.rawValue)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: KdRadius.button.rawValue, style: .continuous)
                    .stroke(KdColor.accent.opacity(configuration.isPressed ? 0.6 : 1.0), lineWidth: 1)
            )
            .contentShape(Rectangle())
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}
