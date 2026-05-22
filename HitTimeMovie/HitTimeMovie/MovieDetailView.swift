import SwiftUI

struct MovieDetailView: View {
    let movie: UserMovie
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var movieStore: MovieStore
    @State private var showTicketForm = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    if let posterImage = movie.posterImage {
                        Image(uiImage: posterImage)
                            .resizable()
                            .aspectRatio(2/3, contentMode: .fit)
                            .frame(maxHeight: 400)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text(movie.title)
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text(movie.genre)
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                            .foregroundColor(.gold)
                        
                        Text("Release Date: \(movie.releaseDate, style: .date)")
                            .font(.system(size: 16, design: .rounded))
                            .foregroundColor(.white.opacity(0.7))
                        
                        Text(movie.description)
                            .font(.system(size: 16, design: .rounded))
                            .foregroundColor(.white.opacity(0.8))
                            .lineSpacing(4)
                        
                        Button("Create Ticket") {
                            showTicketForm = true
                        }
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.gold)
                        )
                        .padding(.top, 10)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .background(Color.black)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundColor(.gold)
                }
            }
        }
        .sheet(isPresented: $showTicketForm) {
            TicketFormView(movieTitle: movie.title)
        }
    }
}

struct TicketFormView: View {
    let movieTitle: String
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var movieStore: MovieStore
    @State private var seatNumber = ""
    @State private var showDate = Date()
    @State private var showTime = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Create Ticket")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                Text("for \(movieTitle)")
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundColor(.gold)
                
                VStack(spacing: 16) {
                    TextField("Seat Number (e.g., A12)", text: $seatNumber)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Show Time (e.g., 7:30 PM)", text: $showTime)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    DatePicker("Show Date", selection: $showDate, displayedComponents: .date)
                        .datePickerStyle(CompactDatePickerStyle())
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 20)
                
                Button("Create Ticket") {
                    let ticket = UserTicket(
                        movieTitle: movieTitle,
                        seatNumber: seatNumber,
                        showDate: showDate,
                        showTime: showTime
                    )
                    movieStore.addTicket(ticket)
                    dismiss()
                }
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(seatNumber.isEmpty || showTime.isEmpty ? Color.gray : Color.gold)
                )
                .disabled(seatNumber.isEmpty || showTime.isEmpty)
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .background(Color.black)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.gold)
                }
            }
        }
    }
}
