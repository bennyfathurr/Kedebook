//
//  KdSearchBar.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 26/10/25.
//

import SwiftUI

import SwiftUI

struct KdSearchBar: View {
    @Binding var text: String
    var placeholder: String
    var onSubmit: () -> Void

    // Explicit init to avoid “takes no arguments” errors
    init(
        text: Binding<String>,
        placeholder: String = "Search books, authors, ISBN",
        onSubmit: @escaping () -> Void = {}
    ) {
        self._text = text
        self.placeholder = placeholder
        self.onSubmit = onSubmit
    }

    var body: some View {
        HStack(spacing: KdSpace.sm) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(KdColor.accent)
            TextField(placeholder, text: $text, onCommit: onSubmit)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
        }
        .padding(KdSpace.md)
        .background(
            RoundedRectangle(cornerRadius: KdRadius.card)
                .fill(KdColor.surfaceCard)
        )
    }
}


#Preview {
    KdSearchBar(text: .constant(""), onSubmit: {})
        .padding()
        .background(Color.gray.opacity(0.2))
}

