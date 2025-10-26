//
//  BookCard.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 26/10/25.
//

import SwiftUI

struct BookCard: View {
    let coverURL: URL?
    let title: String
    let author: String
    var progress: Double? = nil // 0...1

    var body: some View {
        VStack(alignment: .leading, spacing: KdSpace.sm.rawValue) {
            AsyncImage(url: coverURL) { phase in
                switch phase {
                case .success(let img): img
                        .resizable()
                        .scaledToFill()
                default:
                    Rectangle().fill(KdColor.divider.opacity(0.3))
                }
            }
            .frame(height: 180)
            .clipShape(RoundedRectangle(cornerRadius: KdRadius.card.rawValue, style: .continuous))

            Text(title)
                .font(KdFont.body.weight(.semibold))
                .lineLimit(2)
                .foregroundStyle(KdColor.textPrimary)

            Text(author)
                .font(KdFont.caption)
                .foregroundStyle(KdColor.textSecondary)

            if let p = progress {
                ProgressView(value: p)
                    .tint(KdColor.accent)
            }
        }
        .padding(KdSpace.md.rawValue)
        .kdMaterialCard()
    }
}
