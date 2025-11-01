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
    @Query private var profiles: [UserProfile]

    @State private var name: String = ""
    @State private var avatarImage: UIImage?
    @State private var pickerItem: PhotosPickerItem?
    @State private var showSavedAlert = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    avatarSection
                    formSection
                    saveButton
                }
                .padding(.top, 40)
                .padding(.horizontal, 20)
            }
            .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .alert("Profile Saved", isPresented: $showSavedAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Your profile information has been updated successfully.")
            }
        }
        .onAppear {
            if let p = profiles.first { name = p.name ?? "" }
        }
    }

    // MARK: - Avatar
    private var avatarSection: some View {
        VStack(spacing: 8) {
            if let image = avatarImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .shadow(radius: 5)
                    .transition(.scale)
            } else if let avatarPath = profiles.first?.avatarPath,
                      let image = UIImage(contentsOfFile: avatarPath) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .shadow(radius: 5)
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundStyle(.secondary)
                    .transition(.opacity)
            }

            PhotosPicker(selection: $pickerItem, matching: .images) {
                Text("Edit Photo")
                    .font(.subheadline)
                    .foregroundColor(.primaryAccent)
            }
            .onChange(of: pickerItem) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        avatarImage = uiImage
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Form Section
    private var formSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your Name")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)

            TextField("Enter your name", text: $name)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Color(uiColor: .secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Save Button
    private var saveButton: some View {
        Button {
            saveProfile()
        } label: {
            Text("Save Changes")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.primaryAccent)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
        }
        .padding(.top, 10)
    }

    // MARK: - Logic
    private func saveProfile() {
        var profile: UserProfile

        if let existing = profiles.first {
            profile = existing
        } else {
            profile = UserProfile(name: name.isEmpty ? "Reader" : name)
            context.insert(profile)
        }

        profile.name = name.isEmpty ? "Reader" : name

        if let image = avatarImage,
           let path = ImageStorage.shared.saveImage(image, name: profile.userID) {
            profile.avatarPath = path
        }

        do {
            try context.save()
            withAnimation { showSavedAlert = true }
        } catch {
            print("❌ Failed to save profile: \(error.localizedDescription)")
        }
    }
}
