//
//  KdToolbar.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 26/10/25.
//

import SwiftUI

struct KdToolbar: View {
    let title: String
    var trailing: AnyView? = nil

    var body: some View {
        HStack {
            Text(title).font(KdFont.h2).foregroundStyle(KdColor.textPrimary)
            Spacer()
            if let trailing { trailing }
        }
        .padding(.horizontal, KdSpace.md)
        .padding(.vertical, KdSpace.md)
        .background(
            Group {
                if #available(iOS 26, *) { AnyView(VisualEffectMaterialView()) }
                else { AnyView(Color.clear) }
            }
        )
    }
}

/// Wrapper view to expose .regularMaterial background uniformly
struct VisualEffectMaterialView: View {
    var body: some View {
        Rectangle()
            .fill(.regularMaterial)
            .ignoresSafeArea(edges: .top)
    }
}
