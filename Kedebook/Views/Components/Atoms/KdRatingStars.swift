//
//  Untitled.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 26/10/25.
//

import SwiftUI

struct KdRatingStars: View {
    let rating: Int // 0...5
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<5, id: \.self) { i in
                Image(systemName: i < rating ? "star.fill" : "star")
                    .foregroundStyle(i < rating ? KdColor.accent : KdColor.iconInactive)
            }
        }
        .font(.caption)
    }
}
