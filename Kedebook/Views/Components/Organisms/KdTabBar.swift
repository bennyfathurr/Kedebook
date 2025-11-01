//
//  Untitled.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 26/10/25.
//

import SwiftUI

enum KdTab: Hashable { case home, search, add, library, profile }

struct KdTabBar: View {
    @Binding var selection: KdTab

    private func tabItem(_ icon: String, _ label: String, _ tab: KdTab) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .symbolVariant(selection == tab ? .fill : .none)
            Text(label).font(.caption2)
        }
        .foregroundStyle(selection == tab ? KdColor.accent : KdColor.iconInactive)
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .onTapGesture { selection = tab }
    }

    var body: some View {
        HStack {
            tabItem("house", "Home", .home)
            tabItem("magnifyingglass", "Search", .search)
            tabItem("plus.circle", "Add", .add)
            tabItem("books.vertical", "Library", .library)
            tabItem("person", "Profile", .profile)
        }
        .padding(.horizontal, KdSpace.md)
        .padding(.top, KdSpace.sm)
        .padding(.bottom, safeBottomPadding)
        .background(tabBackground)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .shadow(color: .black.opacity(0.05), radius: 10, y: -2)
        .padding(.horizontal, 24)
    }

    // MARK: - Adaptive styling

    private var tabBackground: some View {
        Group {
            if #available(iOS 26, *) {
                // Native “liquid glass” background
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .background(.regularMaterial.opacity(0.6))
            } else {
                // Custom flat translucent background
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(Color.white.opacity(0.85))
                    .background(Color.white)
            }
        }
    }

    private var safeBottomPadding: CGFloat {
        max(KdSpace.sm, UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow?.safeAreaInsets.bottom }
            .first ?? 0)
    }
}
