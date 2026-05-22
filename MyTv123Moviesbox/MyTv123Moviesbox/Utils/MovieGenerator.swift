//
//  MovieGenerator.swift
//  MyTv123Moviesbox
//
//  Generate sample movies and shows
//

import Foundation

struct MovieGenerator {
    static func generateSampleMovies() -> [MovieModel] {
        let movies = [
            // Popular Movies
            MovieModel(
                title: "Avatar: The Way of Water",
                genre: "Action, Adventure, Sci-Fi",
                description: "Jake Sully lives with his newfound family formed on the extrasolar moon Pandora.",
                duration: "3h 12min",
                posterURL: "",
                isFavorite: false,
                isWatched: false,
                watchProgress: 0.0,
                releaseYear: "2022",
                rating: 7.6,
                imdbRating: 7.6,
                director: "James Cameron",
                cast: ["Sam Worthington", "Zoe Saldana", "Sigourney Weaver"],
                language: "English",
                subtitles: ["English", "Spanish", "French"],
                categories: ["Action", "Adventure", "Sci-Fi"],
                quality: .fourK,
                personalNotes: "",
                tags: ["blockbuster", "sequel"],
                contentType: .movie,
                ageRating: "PG-13",
                country: "USA",
                popularity: 9.2,
                trendingScore: 9.5
            ),
            
            MovieModel(
                title: "Top Gun: Maverick",
                genre: "Action, Drama",
                description: "After thirty years, Maverick is still pushing the envelope as a top naval aviator.",
                duration: "2h 10min",
                posterURL: "",
                isFavorite: true,
                isWatched: true,
                watchProgress: 1.0,
                releaseYear: "2022",
                rating: 8.3,
                imdbRating: 8.3,
                director: "Joseph Kosinski",
                cast: ["Tom Cruise", "Miles Teller", "Jennifer Connelly"],
                language: "English",
                subtitles: ["English", "Spanish"],
                categories: ["Action", "Drama"],
                quality: .fourK,
                personalNotes: "Amazing sequel!",
                tags: ["sequel", "action"],
                contentType: .movie,
                ageRating: "PG-13",
                country: "USA",
                popularity: 9.0,
                trendingScore: 9.3
            ),
            
            MovieModel(
                title: "Black Panther: Wakanda Forever",
                genre: "Action, Adventure, Drama",
                description: "The people of Wakanda fight to protect their home from intervening world powers.",
                duration: "2h 41min",
                posterURL: "",
                isFavorite: false,
                isWatched: false,
                watchProgress: 0.3,
                releaseYear: "2022",
                rating: 6.7,
                imdbRating: 6.7,
                director: "Ryan Coogler",
                cast: ["Letitia Wright", "Lupita Nyong'o", "Danai Gurira"],
                language: "English",
                subtitles: ["English", "Spanish", "French"],
                categories: ["Action", "Adventure", "Drama"],
                quality: .fourK,
                personalNotes: "",
                tags: ["marvel", "superhero"],
                contentType: .movie,
                ageRating: "PG-13",
                country: "USA",
                popularity: 8.5,
                trendingScore: 8.8
            ),
            
            // TV Shows
            MovieModel(
                title: "House of the Dragon",
                genre: "Action, Adventure, Drama",
                description: "An internal succession war within House Targaryen at the height of its power.",
                duration: "60min per episode",
                posterURL: "",
                isFavorite: true,
                isWatched: false,
                watchProgress: 0.6,
                releaseYear: "2022",
                rating: 8.5,
                imdbRating: 8.5,
                director: "Ryan Condal",
                cast: ["Paddy Considine", "Emma D'Arcy", "Matt Smith"],
                language: "English",
                subtitles: ["English", "Spanish", "French", "German"],
                categories: ["Fantasy", "Drama", "Action"],
                quality: .fourK,
                personalNotes: "Better than expected",
                tags: ["hbo", "fantasy"],
                seasons: 1,
                episodes: 10,
                contentType: .tvShow,
                ageRating: "TV-MA",
                country: "USA",
                popularity: 9.1,
                trendingScore: 9.4
            ),
            
            MovieModel(
                title: "Wednesday",
                genre: "Comedy, Crime, Horror",
                description: "Follows Wednesday Addams' years as a student at Nevermore Academy.",
                duration: "50min per episode",
                posterURL: "",
                isFavorite: true,
                isWatched: true,
                watchProgress: 1.0,
                releaseYear: "2022",
                rating: 8.1,
                imdbRating: 8.1,
                director: "Alfred Gough",
                cast: ["Jenna Ortega", "Hunter Doohan", "Percy Hynes White"],
                language: "English",
                subtitles: ["English", "Spanish", "French"],
                categories: ["Comedy", "Horror", "Mystery"],
                quality: .fourK,
                personalNotes: "Jenna Ortega is perfect!",
                tags: ["netflix", "comedy"],
                seasons: 1,
                episodes: 8,
                contentType: .tvShow,
                ageRating: "TV-14",
                country: "USA",
                popularity: 9.3,
                trendingScore: 9.6
            ),
            
            MovieModel(
                title: "The Bear",
                genre: "Comedy, Drama",
                description: "A young chef from the fine dining world returns to Chicago to run his family's sandwich shop.",
                duration: "30min per episode",
                posterURL: "",
                isFavorite: false,
                isWatched: false,
                watchProgress: 0.0,
                releaseYear: "2022",
                rating: 8.7,
                imdbRating: 8.7,
                director: "Christopher Storer",
                cast: ["Jeremy Allen White", "Ebon Moss-Bachrach", "Ayo Edebiri"],
                language: "English",
                subtitles: ["English"],
                categories: ["Comedy", "Drama"],
                quality: .hd,
                personalNotes: "",
                tags: ["fx", "comedy-drama"],
                seasons: 2,
                episodes: 18,
                contentType: .tvShow,
                ageRating: "TV-MA",
                country: "USA",
                popularity: 8.9,
                trendingScore: 9.2
            ),
            
            // More Movies
            MovieModel(
                title: "Everything Everywhere All at Once",
                genre: "Action, Adventure, Comedy",
                description: "A middle-aged Chinese immigrant is swept up into an insane adventure.",
                duration: "2h 19min",
                posterURL: "",
                isFavorite: true,
                isWatched: true,
                watchProgress: 1.0,
                releaseYear: "2022",
                rating: 7.8,
                imdbRating: 7.8,
                director: "Daniels",
                cast: ["Michelle Yeoh", "Stephanie Hsu", "Ke Huy Quan"],
                language: "English",
                subtitles: ["English", "Chinese"],
                categories: ["Sci-Fi", "Comedy", "Action"],
                quality: .fourK,
                personalNotes: "Mind-blowing!",
                tags: ["indie", "multiverse"],
                contentType: .movie,
                ageRating: "R",
                country: "USA",
                popularity: 8.7,
                trendingScore: 9.0
            ),
            
            MovieModel(
                title: "Dune",
                genre: "Action, Adventure, Drama",
                description: "Paul Atreides arrives on Arrakis after his father accepts the stewardship of the dangerous planet.",
                duration: "2h 35min",
                posterURL: "",
                isFavorite: false,
                isWatched: false,
                watchProgress: 0.0,
                releaseYear: "2021",
                rating: 8.0,
                imdbRating: 8.0,
                director: "Denis Villeneuve",
                cast: ["Timothée Chalamet", "Rebecca Ferguson", "Oscar Isaac"],
                language: "English",
                subtitles: ["English", "Spanish", "French"],
                categories: ["Sci-Fi", "Adventure", "Drama"],
                quality: .fourK,
                personalNotes: "",
                tags: ["epic", "sci-fi"],
                contentType: .movie,
                ageRating: "PG-13",
                country: "USA",
                popularity: 8.8,
                trendingScore: 8.5
            )
        ]
        
        return movies
    }
    
    static func addSampleMoviesToManager() {
        let dataManager = MovieDataManager.shared
        let sampleMovies = generateSampleMovies()
        
        for movie in sampleMovies {
            dataManager.addMovie(movie)
        }
    }
}
