import Foundation

// MARK: - App Error
enum AppError: LocalizedError {
    case saveFailed
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .saveFailed:     return "Failed to save. Please try again."
        case .unknown(let e): return e.localizedDescription
        }
    }
}
