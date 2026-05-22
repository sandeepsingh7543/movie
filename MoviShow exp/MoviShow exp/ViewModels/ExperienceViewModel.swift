// ExperienceViewModel.swift - Mood-based Discovery Engine

import SwiftUI
import Observation

@Observable
class ExperienceViewModel {
    var library: LibraryViewModel
    var selectedMood: Mood? = nil
    var currentIndex: Int = 0
    var offset: CGSize = .zero
    
    init(library: LibraryViewModel) {
        self.library = library
    }
    
    // Movies come from library
    var movies: [Movie] { library.movies }
    
    // Filtered movies based on mood
    var filteredMovies: [Movie] {
        guard let mood = selectedMood else { return movies }
        return movies.filter { $0.mood == mood }
    }
    
    var currentMovie: Movie? {
        guard !filteredMovies.isEmpty, currentIndex < filteredMovies.count else { return nil }
        return filteredMovies[currentIndex]
    }
    
    func selectMood(_ mood: Mood?) {
        selectedMood = mood
        currentIndex = 0
    }
    
    func swipeNext() {
        guard currentIndex < filteredMovies.count - 1 else {
            currentIndex = 0
            return
        }
        currentIndex += 1
    }
    
    func swipePrevious() {
        guard currentIndex > 0 else { return }
        currentIndex -= 1
    }
    
    func addToJourney(_ movie: Movie) -> JourneyEntry {
        JourneyEntry(movie: movie, watchedDate: Date())
    }
}
