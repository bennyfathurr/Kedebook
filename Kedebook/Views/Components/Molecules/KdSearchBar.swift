//
//  KdSearchBar.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 26/10/25.
//

import SwiftUI

struct KdSearchBar: View {
    @Binding var text: String
    var placeholder: String = "Search books, authors, ISBN"
    var onSubmit: () -> Void = {}

    var body: some View {
        HStack(spacing: KdSpace.sm.rawValue) {
            Image(systemName: "magnifyingglass").foregroundStyle(KdColor.accent)
            TextField(placeholder, text: $text, onCommit: onSubmit)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
        }
        .padding(KdSpace.md.rawValue)
        .background(
            RoundedRectangle(cornerRadius: KdRadius.card.rawValue, style: .continuous)
                .fill(KdColor.surfaceCard)
        )
    }
}
