//
//  KdDivider.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 26/10/25.
//

import SwiftUI
struct KdDivider: View {
    var body: some View {
        Rectangle()
            .fill(KdColor.divider)
            .frame(height: 1 / UIScreen.main.scale)
    }
}
