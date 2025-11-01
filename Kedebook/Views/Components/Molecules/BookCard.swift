//
//  BookCard.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 26/10/25.
//

//
//  BookCard.swift
//  Kedebook
//

import SwiftUI

struct BookCard: View {
    let coverURL: URL?
    let title: String
    let author: String

    var body: some View {
        VStack(spacing: KdSpace.md) {
            // MARK: - Cover Image
            AsyncImage(url: coverURL) { phase in
                switch phase {
                case .success(let img):
                    img.resizable().scaledToFit() // keep proportion
                default:
                    Rectangle().fill(Color.gray.opacity(0.15))
                }
            }
            .frame(height: 200)
            .clipShape(RoundedRectangle(cornerRadius: KdRadius.card))
            .shadow(color: .black.opacity(0.05), radius: 4, y: 2)

            // MARK: - Text Section
            VStack(alignment: .center, spacing: 4) {
                Text(title)
                    .font(KdFont.body.weight(.semibold))
                    .foregroundStyle(KdColor.textPrimary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .truncationMode(.tail)

                Text(author)
                    .font(KdFont.caption)
                    .foregroundStyle(KdColor.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical, KdSpace.md)
        .padding(.horizontal, KdSpace.sm)
        .frame(
            width: UIScreen.main.bounds.width < 400 ? 170 : 175,
            height: UIScreen.main.bounds.width < 400 ? 290 : 310,
            alignment: .center
        )
        .kdCard()
    }
}
