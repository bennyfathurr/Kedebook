//
//  KdPrimaryButton.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 26/10/25.
//

import SwiftUI

struct KdPrimaryButton: View {
    let title: String
    var action: () -> Void
    var body: some View {
        Button(title, action: action)
            .buttonStyle(KdPrimaryButtonStyle())
    }
}
