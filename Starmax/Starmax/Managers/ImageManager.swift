import Foundation
import SwiftUI
import UIKit

@MainActor
final class ImageManager {
    static let shared = ImageManager()

    private let fileManager = FileManager.default
    private let cache = NSCache<NSString, UIImage>()
    private let posterFolderURL: URL

    private init() {
        let baseURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
            ?? fileManager.temporaryDirectory
        posterFolderURL = baseURL.appendingPathComponent("Starmax/Posters", isDirectory: true)

        try? fileManager.createDirectory(at: posterFolderURL, withIntermediateDirectories: true)
    }

    func savePosterImage(_ image: UIImage) throws -> String {
        let key = UUID().uuidString
        let targetURL = posterFolderURL.appendingPathComponent(key).appendingPathExtension("jpg")
        let resized = resize(image: image, maxDimension: 1600)
        guard let data = resized.jpegData(compressionQuality: 0.82) else {
            throw NSError(domain: "Starmax", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to encode poster image"])
        }
        try data.write(to: targetURL, options: [.atomic])
        cache.setObject(resized, forKey: targetURL.path as NSString)
        return targetURL.path
    }

    func image(for path: String?) -> UIImage? {
        guard let path else { return nil }
        if let cached = cache.object(forKey: path as NSString) {
            return cached
        }
        let url = URL(fileURLWithPath: path)
        guard let image = UIImage(contentsOfFile: url.path) else { return nil }
        cache.setObject(image, forKey: path as NSString)
        return image
    }

    func swiftUIImage(for path: String?) -> Image? {
        guard let image = image(for: path) else { return nil }
        return Image(uiImage: image)
    }

    func deleteImage(at path: String?) {
        guard let path else { return }
        cache.removeObject(forKey: path as NSString)
        try? fileManager.removeItem(atPath: path)
    }

    func clearAllImages() {
        cache.removeAllObjects()
        try? fileManager.removeItem(at: posterFolderURL)
        try? fileManager.createDirectory(at: posterFolderURL, withIntermediateDirectories: true)
    }

    func importedImage(from data: Data, maxDimension: CGFloat = 1600) -> UIImage? {
        guard let image = UIImage(data: data) else { return nil }
        return resize(image: image, maxDimension: maxDimension)
    }

    private func resize(image: UIImage, maxDimension: CGFloat) -> UIImage {
        let size = image.size
        guard size.width > maxDimension || size.height > maxDimension else {
            return image
        }

        let scale = min(maxDimension / size.width, maxDimension / size.height)
        let targetSize = CGSize(width: size.width * scale, height: size.height * scale)
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}

