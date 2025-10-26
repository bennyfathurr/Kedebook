//
//  ProfileView.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 25/10/25.
//

import SwiftUI
import PhotosUI
import SwiftData

struct ProfileView: View {
    @Environment(\.modelContext) private var context
    @State private var profile: UserProfile?
    @State private var name: String = ""
    //@State private var email: String = ""
    @State private var avatarImage: UIImage?
    @State private var selectedPhoto: PhotosPickerItem?

    var body: some View {
        Form {
            Section(header: Text("Profile")) {
                if let image = avatarImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .padding(.bottom)
                } else {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 100, height: 100)
                        .overlay(Text("Add Photo"))
                }

                PhotosPicker(selection: $selectedPhoto, matching: .images) {
                    Text("Select Photo")
                }

                TextField("Name", text: $name)
                //TextField("Email", text: $email)
            }

            Button("Save") {
                guard let profile else { return }

                if let image = avatarImage,
                   let savedPath = ImageStorage.shared.saveImage(image, name: profile.userID) {
                    profile.avatarPath = savedPath
                }
                profile.name = name
                do { try context.save(); print("Profile saved") }
                catch { print("Save failed:", error) }

            }

        }
        .navigationTitle("Profile")
        .onAppear {
            let p = ProfileStore.shared.getOrCreateProfile(context: context)
            profile = p
            name = p.name
            if let image = ImageStorage.shared.loadImage(from: p.avatarPath) {
                avatarImage = image
            }
        }
        .onChange(of: selectedPhoto) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    avatarImage = image
                }
            }
        }
    }
}

