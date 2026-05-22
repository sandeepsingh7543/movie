# CineTrack Pro

A production-ready iOS movie tracking app built with SwiftUI that helps users manage their personal movie library.

## Features

### Core Features
- **Add Movies Manually**: Add movies with title, genre, rating (1-10), watch status, personal notes, poster images, and release dates
- **Smart Lists**: Auto-generated sections including "Watch Tonight", "Top Rated by You", "Recently Added", and "Forgotten Movies"
- **Movie Detail Screen**: Full-screen poster view with smooth animations and complete movie information
- **Offline First**: Uses local storage with no external API dependencies or login requirements
- **Search & Filter**: Search by title and filter by genre, rating, or watch status

### Unique Features
- **Mood Picker**: Select your mood (Happy, Sad, Action, Chill) and get movie suggestions from your library
- **Backup Feature**: Export/import movies as JSON files
- **Dark Premium UI**: Pure black background with yellow accents, modern card-based layout

### App Store Compliance
- No copyrighted API content
- No misleading metadata
- Fully functional UI with no dead buttons
- Proper empty states and loading states
- Demo data on first launch

## Technical Details

### Architecture
- **SwiftUI** with MVVM architecture
- **Clean code structure** with organized folders
- **NavigationStack** for modern navigation
- **Smooth animations** using `withAnimation`
- **Proper state management** with `@StateObject` and `@ObservedObject`

### UI/UX
- **Dark mode** (default ON with toggle in settings)
- **SF Symbols** for consistent iconography
- **Grid and card layouts** for modern appearance
- **Bottom Tab Bar** navigation (Home, Add Movie, Library, Settings)
- **Rounded corners** (16-24px radius) with shadow and glass effects

### Data Management
- **Local storage** using UserDefaults for persistence
- **JSON encoding/decoding** for data serialization
- **Photo library integration** for poster images
- **Backup and restore** functionality

## Project Structure

```
CineTrack Pro/
├── Models/
│   └── Movie.swift                 # Data models and enums
├── ViewModels/
│   └── MovieViewModel.swift        # Business logic and data management
├── Views/
│   ├── HomeView.swift             # Dashboard with stats and smart lists
│   ├── AddMovieView.swift         # Add new movies
│   ├── EditMovieView.swift        # Edit existing movies
│   ├── LibraryView.swift          # Browse all movies with search/filter
│   ├── MovieDetailView.swift      # Detailed movie information
│   ├── SettingsView.swift         # App settings and data management
│   ├── FilterView.swift           # Filter options
│   ├── MoodMoviesView.swift       # Mood-based movie suggestions
│   └── MainTabView.swift          # Main tab navigation
├── Assets.xcassets/               # App icons and colors
└── Preview Content/               # Preview assets
```

## Requirements

- iOS 18.2+
- Xcode 16.2+
- Swift 5.0+

## Installation

1. Clone the repository
2. Open `CineTrack Pro.xcodeproj` in Xcode
3. Build and run on iOS Simulator or device

## App Store Readiness

This app is designed to pass Apple's App Store review process:

- ✅ No external API dependencies
- ✅ No copyrighted content
- ✅ Fully functional offline experience
- ✅ Proper error handling and empty states
- ✅ Clean, intuitive user interface
- ✅ Follows iOS Human Interface Guidelines
- ✅ Includes demo data for immediate functionality

## License

This project is created for educational and demonstration purposes.