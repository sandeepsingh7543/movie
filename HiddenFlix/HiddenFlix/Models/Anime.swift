import Foundation
import SwiftUI

struct Anime: Identifiable, Codable {
    var id = UUID()
    var title: String
    var description: String
    var mainImage: Data?
    var screenshots: [Data] = []
    var releaseDate: Date = Date()
    var category: String = ""
    
    init(id: UUID = UUID(), title: String, description: String, mainImage: Data? = nil, screenshots: [Data] = [], releaseDate: Date = Date(), category: String = "") {
        self.id = id
        self.title = title
        self.description = description
        self.mainImage = mainImage
        self.screenshots = screenshots
        self.releaseDate = releaseDate
        self.category = category
    }
    
    var mainImageView: Image? {
        if let mainImage = mainImage, let uiImage = UIImage(data: mainImage) {
            return Image(uiImage: uiImage)
        }
        return nil
    }
    
    var screenshotViews: [Image] {
        return screenshots.compactMap { UIImage(data: $0) }.map { Image(uiImage: $0) }
    }
}
