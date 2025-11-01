//
//  FeaturedBookCard.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 26/10/25.
//

import SwiftUI

struct FeaturedBookCard: View {
    let coverURL: URL?
    let title: String
    let author: String
    let rating: Double // e.g., 4.3

    var body: some View {
        HStack(spacing: KdSpace.md) {
            // Book cover
            AsyncImage(url: coverURL) { phase in
                switch phase {
                case .success(let img):
                    img.resizable().scaledToFill()
                default:
                    Rectangle().fill(Color.gray.opacity(0.15))
                }
            }
            .frame(width: 80, height: 110)
            .clipShape(RoundedRectangle(cornerRadius: KdRadius.card))

            // Text + rating
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(KdFont.h3)
                    .foregroundStyle(KdColor.textPrimary)
                    .lineLimit(2)
                    .truncationMode(.tail)

                Text(author)
                    .font(KdFont.body)
                    .foregroundStyle(KdColor.textSecondary)
                    .lineLimit(1)

                // Rating stars
                HStack(spacing: 2) {
                    ForEach(0..<5) { index in
                        Image(systemName: index < Int(rating.rounded(.down))
                              ? "star.fill"
                              : (rating - Double(index) > 0.5 ? "star.leadinghalf.filled" : "star"))
                            .symbolRenderingMode(.multicolor)
                            .foregroundStyle(
                                index < Int(rating.rounded(.down)) ? KdColor.accent : .gray.opacity(0.4)
                            )
                    }

                    Text(String(format: "%.1f", rating))
                        .font(KdFont.caption)
                        .foregroundStyle(KdColor.textSecondary)
                        .padding(.leading, 4)
                }
                .padding(.top, 2)
            }

            Spacer(minLength: 0)
        }
        .padding(KdSpace.md)
        .frame(maxWidth: .infinity, minHeight: 140)
        .kdCard()
    }
}
