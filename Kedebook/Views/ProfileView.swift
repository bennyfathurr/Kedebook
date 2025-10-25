//
//  ProfileView.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 25/10/25.
//

import SwiftUI
import SwiftData

struct ProfileView: View {
    @Environment(\.modelContext) private var context
    @State private var name: String = ""
    //@State private var email: String = ""
    @State private var avatarURLText: String = ""

    @State private var profile: UserProfile?

    var body: some View {
        Form {
            Section(header: Text("Profile")) {
                TextField("Name", text: $name)
                //TextField("Email", text: $email)
                TextField("Avatar URL", text: $avatarURLText)
            }
            Button("Save") {
                guard let profile else { return }
                ProfileStore.shared.updateProfile(
                    profile,
                    name: name,
                    //email: email.isEmpty ? nil : email,
                    avatarURL: URL(string: avatarURLText),
                    context: context
                )
            }
        }
        .navigationTitle("Profile")
        .onAppear {
            let p = ProfileStore.shared.getOrCreateProfile(context: context)
            profile = p
            name = p.name
            //email = p.email ?? ""
            avatarURLText = p.avatarURL?.absoluteString ?? ""
        }
    }
}
