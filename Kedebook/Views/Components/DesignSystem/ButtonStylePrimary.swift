//
//  ButtonStylePrimary.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 26/10/25.
//

import SwiftUI

struct KdPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(KdFont.body.weight(.semibold))
            .foregroundStyle(Color.white)
            .padding(.vertical, KdSpace.md)
            .frame(maxWidth: .infinity)
            .background(KdColor.accent.opacity(configuration.isPressed ? 0.85 : 1.0))
            .clipShape(RoundedRectangle(cornerRadius: KdRadius.button, style: .continuous))
            .contentShape(Rectangle())
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}
