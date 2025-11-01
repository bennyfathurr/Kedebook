//
//  Untitled.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 26/10/25.
//

import SwiftUI

struct ReviewCard: View {
    let avatar: Image?
    let username: String
    let rating: Int
    let bodyText: String
    let timestamp: String

    var body: some View {
        VStack(alignment: .leading, spacing: KdSpace.sm) {
            HStack(spacing: KdSpace.sm) {
                (avatar ?? Image(systemName: "person.circle.fill"))
                    .resizable().frame(width: 32, height: 32).clipShape(Circle())
                VStack(alignment: .leading, spacing: 2) {
                    Text(username).font(KdFont.body.weight(.semibold)).foregroundStyle(KdColor.textPrimary)
                    Text(timestamp).font(KdFont.caption).foregroundStyle(KdColor.textSecondary)
                }
                Spacer()
                KdRatingStars(rating: rating)
            }
            Text(bodyText)
                .font(KdFont.body)
                .foregroundStyle(KdColor.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(KdSpace.md)
        .kdCard()
    }
}
