import SwiftUI
import CoreData

struct MovieQuizView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @FetchRequest(sortDescriptors: []) private var movies: FetchedResults<Movie>
    
    @State private var currentQuestion = 0
    @State private var score = 0
    @State private var selectedAnswer: String?
    @State private var showingResult = false
    @State private var quizQuestions: [QuizQuestion] = []
    @State private var quizCompleted = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                if quizQuestions.isEmpty {
                    loadingView
                } else if quizCompleted {
                    resultView
                } else {
                    quizView
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            generateQuizQuestions()
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .purple))
                .scaleEffect(1.5)
            
            Text("Preparing Quiz...")
                .font(.custom("Inter", size: 18).weight(.medium))
                .foregroundColor(.white)
        }
    }
    
    private var quizView: some View {
        VStack(spacing: 24) {
            headerSection
            
            if currentQuestion < quizQuestions.count {
                questionSection
                
                answersSection
                
                if selectedAnswer != nil {
                    nextButton
                }
            }
            
            Spacer()
        }
        .padding()
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            HStack {
                Button("Close") {
                    dismiss()
                }
                .foregroundColor(.purple)
                
                Spacer()
                
                Text("Question \(currentQuestion + 1) of \(quizQuestions.count)")
                    .font(.custom("Inter", size: 16).weight(.medium))
                    .foregroundColor(.gray)
            }
            
            ProgressView(value: Double(currentQuestion), total: Double(quizQuestions.count))
                .progressViewStyle(LinearProgressViewStyle(tint: .purple))
                .scaleEffect(y: 2)
            
            HStack {
                Text("Score: \(score)")
                    .font(.custom("Inter", size: 18).weight(.semibold))
                    .foregroundColor(.white)
                
                Spacer()
            }
        }
    }
    
    private var questionSection: some View {
        VStack(spacing: 16) {
            Text(quizQuestions[currentQuestion].question)
                .font(.custom("Inter", size: 22).weight(.semibold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding()
                .background(.purple.opacity(0.1))
                .cornerRadius(16)
        }
    }
    
    private var answersSection: some View {
        VStack(spacing: 12) {
            ForEach(quizQuestions[currentQuestion].options, id: \.self) { option in
                Button(action: { selectAnswer(option) }) {
                    HStack {
                        Text(option)
                            .font(.custom("Inter", size: 16).weight(.medium))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                        
                        if selectedAnswer == option {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.purple)
                        }
                    }
                    .padding()
                    .background(selectedAnswer == option ? .purple.opacity(0.2) : .gray.opacity(0.1))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(selectedAnswer == option ? .purple : .clear, lineWidth: 2)
                    )
                }
                .disabled(selectedAnswer != nil)
            }
        }
    }
    
    private var nextButton: some View {
        Button(action: nextQuestion) {
            Text(currentQuestion == quizQuestions.count - 1 ? "Finish Quiz" : "Next Question")
                .font(.custom("Inter", size: 18).weight(.semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(.purple)
                .cornerRadius(28)
        }
    }
    
    private var resultView: some View {
        VStack(spacing: 24) {
            Image(systemName: "trophy.fill")
                .font(.system(size: 80))
                .foregroundColor(.yellow)
            
            Text("Quiz Complete!")
                .font(.custom("Inter", size: 32).weight(.bold))
                .foregroundColor(.white)
            
            Text("Your Score")
                .font(.custom("Inter", size: 18))
                .foregroundColor(.gray)
            
            Text("\(score) / \(quizQuestions.count)")
                .font(.custom("Inter", size: 48).weight(.bold))
                .foregroundColor(.purple)
            
            Text(getScoreMessage())
                .font(.custom("Inter", size: 16))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 12) {
                Button(action: restartQuiz) {
                    Text("Play Again")
                        .font(.custom("Inter", size: 18).weight(.semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(.purple)
                        .cornerRadius(28)
                }
                
                Button(action: { dismiss() }) {
                    Text("Close")
                        .font(.custom("Inter", size: 16).weight(.medium))
                        .foregroundColor(.purple)
                }
            }
        }
        .padding()
    }
    
    private func generateQuizQuestions() {
        guard movies.count >= 3 else {
            quizQuestions = []
            return
        }
        
        var questions: [QuizQuestion] = []
        let movieArray = Array(movies)
        
        // Generate different types of questions
        for _ in 0..<min(5, movieArray.count) {
            let randomMovie = movieArray.randomElement()!
            let questionType = Int.random(in: 0...2)
            
            switch questionType {
            case 0: // Genre question
                let correctGenre = randomMovie.genre
                var options = [correctGenre]
                let allGenres = ["Action", "Comedy", "Drama", "Horror", "Romance", "Sci-Fi", "Thriller", "Animation"]
                
                while options.count < 4 {
                    let randomGenre = allGenres.randomElement()!
                    if !options.contains(randomGenre) {
                        options.append(randomGenre)
                    }
                }
                
                questions.append(QuizQuestion(
                    question: "What genre is '\(randomMovie.title)'?",
                    options: options.shuffled(),
                    correctAnswer: correctGenre
                ))
                
            case 1: // Rating question
                let correctRating = String(format: "%.1f", randomMovie.rating)
                var options = [correctRating]
                
                while options.count < 4 {
                    let randomRating = String(format: "%.1f", Double.random(in: 5.0...9.5))
                    if !options.contains(randomRating) {
                        options.append(randomRating)
                    }
                }
                
                questions.append(QuizQuestion(
                    question: "What is the rating of '\(randomMovie.title)'?",
                    options: options.shuffled(),
                    correctAnswer: correctRating
                ))
                
            default: // Year question
                let correctYear = String(randomMovie.releaseYear)
                var options = [correctYear]
                
                while options.count < 4 {
                    let randomYear = String(Int.random(in: 2015...2025))
                    if !options.contains(randomYear) {
                        options.append(randomYear)
                    }
                }
                
                questions.append(QuizQuestion(
                    question: "When was '\(randomMovie.title)' released?",
                    options: options.shuffled(),
                    correctAnswer: correctYear
                ))
            }
        }
        
        quizQuestions = questions
    }
    
    private func selectAnswer(_ answer: String) {
        selectedAnswer = answer
        
        if answer == quizQuestions[currentQuestion].correctAnswer {
            score += 1
        }
    }
    
    private func nextQuestion() {
        if currentQuestion < quizQuestions.count - 1 {
            currentQuestion += 1
            selectedAnswer = nil
        } else {
            quizCompleted = true
        }
    }
    
    private func restartQuiz() {
        currentQuestion = 0
        score = 0
        selectedAnswer = nil
        quizCompleted = false
        generateQuizQuestions()
    }
    
    private func getScoreMessage() -> String {
        let percentage = Double(score) / Double(quizQuestions.count)
        
        switch percentage {
        case 0.8...1.0:
            return "Excellent! You're a true movie expert! 🎬"
        case 0.6..<0.8:
            return "Great job! You know your movies well! 🍿"
        case 0.4..<0.6:
            return "Not bad! Keep watching more movies! 🎭"
        default:
            return "Keep exploring! There's so much to discover! 🎪"
        }
    }
}

struct QuizQuestion {
    let question: String
    let options: [String]
    let correctAnswer: String
}

#Preview {
    MovieQuizView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
