//
//  ImageStorage.swift
//  Kedebook
//
//  Created by Muhammad Benny Fathurrahman on 25/10/25.
//

import UIKit

final class ImageStorage {
    static let shared = ImageStorage()
    private init() {}

    private var directory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    func saveImage(_ image: UIImage, name: String) -> String? {
        let url = directory.appendingPathComponent("\(name).jpg")
        guard let data = image.jpegData(compressionQuality: 0.9) else { return nil }
        do {
            try data.write(to: url)
            return url.path
        } catch {
            print("⚠️ Failed to save image:", error)
            return nil
        }
    }

    func loadImage(from path: String?) -> UIImage? {
        guard let path else { return nil }
        return UIImage(contentsOfFile: path)
    }

    func deleteImage(_ path: String?) {
        guard let path else { return }
        try? FileManager.default.removeItem(atPath: path)
    }
}
