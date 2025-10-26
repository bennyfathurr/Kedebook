//
//  Untitled.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 26/10/25.
//

import SwiftUI

struct KdChip: View {
    let title: String
    let isSelected: Bool
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(KdFont.caption.weight(.semibold))
                .padding(.horizontal, KdSpace.md.rawValue)
                .padding(.vertical, KdSpace.sm.rawValue)
                .background(isSelected ? KdColor.accent : KdColor.surfaceCard)
                .foregroundStyle(isSelected ? Color.white : KdColor.textPrimary)
                .clipShape(RoundedRectangle(cornerRadius: KdRadius.chip.rawValue, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}
