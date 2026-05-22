import SwiftUI
import CoreImage.CIFilterBuiltins

struct TicketsView: View {
    @EnvironmentObject var movieStore: MovieStore
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom Navigation Header
                HStack {
                    Text("My Tickets")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 20)
                
                if movieStore.tickets.isEmpty {
                    Spacer()
                    VStack(spacing: 20) {
                        Image(systemName: "ticket")
                            .font(.system(size: 60))
                            .foregroundColor(.gold.opacity(0.5))
                        
                        Text("No Tickets Yet")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("Create tickets from your movies")
                            .font(.system(size: 16, design: .rounded))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(movieStore.tickets) { ticket in
                                TicketCard(ticket: ticket)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
    }
}

struct TicketCard: View {
    let ticket: UserTicket
    @State private var showingShareSheet = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Ticket Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(ticket.movieTitle)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .lineLimit(2)
                    
                    Text("Seat \(ticket.seatNumber)")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(.gold)
                }
                
                Spacer()
                
                // QR Code
                QRCodeView(text: ticket.qrCode)
                    .frame(width: 80, height: 80)
            }
            .padding(20)
            
            // Ticket Details
            VStack(spacing: 12) {
                HStack {
                    Text("Show Time:")
                        .foregroundColor(.white.opacity(0.7))
                    Spacer()
                    Text(ticket.showTime)
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                }
                
                HStack {
                    Text("Date:")
                        .foregroundColor(.white.opacity(0.7))
                    Spacer()
                    Text(ticket.showDate, style: .date)
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                }
                
                HStack {
                    Text("Venue:")
                        .foregroundColor(.white.opacity(0.7))
                    Spacer()
                    Text("My Movie Vault")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            
            // Action buttons
            HStack(spacing: 15) {
                Button("Share Ticket") {
                    showingShareSheet = true
                }
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(.gold)
                .padding(.vertical, 8)
                .padding(.horizontal, 20)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gold, lineWidth: 1)
                )
                
                Button("Add to Wallet") {
                    // Wallet functionality would go here
                }
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(.black)
                .padding(.vertical, 8)
                .padding(.horizontal, 20)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.gold)
                )
            }
            .padding(.bottom, 20)
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gold.opacity(0.3), lineWidth: 1)
                )
        )
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(items: [createTicketText()])
        }
    }
    
    private func createTicketText() -> String {
        return """
        🎬 Movie Ticket
        
        Movie: \(ticket.movieTitle)
        Seat: \(ticket.seatNumber)
        Date: \(ticket.showDate.formatted(date: .abbreviated, time: .omitted))
        Time: \(ticket.showTime)
        
        QR Code: \(ticket.qrCode)
        
        Generated by My Movie Vault
        """
    }
}

struct QRCodeView: View {
    let text: String
    
    var body: some View {
        Image(uiImage: generateQRCode(from: text))
            .interpolation(.none)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
    
    private func generateQRCode(from string: String) -> UIImage {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
