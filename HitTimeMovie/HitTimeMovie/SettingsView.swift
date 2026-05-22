import SwiftUI

struct SettingsView: View {
    @State private var showingHowToUse = false
    @State private var showingPrivacyPolicy = false
    @State private var showingFeedback = false
    @State private var showingAbout = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Settings")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 20)
                
                ScrollView {
                    VStack(spacing: 25) {
                        // App Info
                        VStack(spacing: 15) {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.gold.opacity(0.2))
                                .frame(width: 80, height: 80)
                                .overlay(
                                    Image(systemName: "film.stack")
                                        .font(.system(size: 40))
                                        .foregroundColor(.gold)
                                )
                            
                            Text("My Movie Vault")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text("Version 1.0.0")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        
                        // Settings Options
                        VStack(spacing: 0) {
                            SettingsRow(
                                icon: "questionmark.circle.fill",
                                title: "How to Use",
                                subtitle: "Learn how to add movies & tickets"
                            ) {
                                showingHowToUse = true
                            }
                            
                            Divider().background(Color.white.opacity(0.2))
                            
                            SettingsRow(
                                icon: "lock.shield.fill",
                                title: "Privacy Policy",
                                subtitle: "Your data stays on your device"
                            ) {
                                showingPrivacyPolicy = true
                            }
                            
                            Divider().background(Color.white.opacity(0.2))
                            
                            SettingsRow(
                                icon: "envelope.fill",
                                title: "Send Feedback",
                                subtitle: "Help us improve the app"
                            ) {
                                showingFeedback = true
                            }
                            
                            Divider().background(Color.white.opacity(0.2))
                            
                            SettingsRow(
                                icon: "info.circle.fill",
                                title: "About",
                                subtitle: "App information"
                            ) {
                                showingAbout = true
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white.opacity(0.05))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.gold.opacity(0.3), lineWidth: 1)
                                )
                        )
                        
                        // About Text
                        VStack(alignment: .leading, spacing: 10) {
                            Text("About My Movie Vault")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("A private movie collection manager. All your data stays on your device. Add movies, create tickets, and manage your personal cinema experience.")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.7))
                                .lineSpacing(4)
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white.opacity(0.05))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.gold.opacity(0.3), lineWidth: 1)
                                )
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
        }
        .sheet(isPresented: $showingHowToUse) {
            HowToUseView()
        }
        .sheet(isPresented: $showingPrivacyPolicy) {
            PrivacyPolicyView()
        }
        .sheet(isPresented: $showingFeedback) {
            FeedbackView()
        }
        .sheet(isPresented: $showingAbout) {
            AboutView()
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(.gold)
                    .frame(width: 25)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                    
                    Text(subtitle)
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.6))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct HowToUseView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Tab Selector
                    HStack(spacing: 0) {
                        Button("Add Movies") {
                            selectedTab = 0
                        }
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(selectedTab == 0 ? .black : .white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(selectedTab == 0 ? Color.gold : Color.clear)
                        )
                        
                        Button("Create Tickets") {
                            selectedTab = 1
                        }
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(selectedTab == 1 ? .black : .white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(selectedTab == 1 ? Color.gold : Color.clear)
                        )
                    }
                    .padding(4)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.1))
                    )
                    .padding(.horizontal, 20)
                    
                    ScrollView {
                        if selectedTab == 0 {
                            AddMovieGuideView()
                        } else {
                            CreateTicketGuideView()
                        }
                    }
                }
            }
            .navigationTitle("How to Use")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundColor(.gold)
                }
            }
        }
    }
}

struct AddMovieGuideView: View {
    var body: some View {
        VStack(spacing: 20) {
            GuideStepView(stepNumber: 1, title: "Go to Add Movie Tab", description: "Tap the '+' icon in bottom tab bar")
            GuideStepView(stepNumber: 2, title: "Choose Poster", description: "Select image from photo library")
            GuideStepView(stepNumber: 3, title: "Fill Details", description: "Enter title, description, genre, date")
            GuideStepView(stepNumber: 4, title: "Save Movie", description: "Tap 'Save Movie' to add to collection")
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 40)
    }
}

struct CreateTicketGuideView: View {
    var body: some View {
        VStack(spacing: 20) {
            GuideStepView(stepNumber: 1, title: "Select Movie", description: "Tap any movie from collection")
            GuideStepView(stepNumber: 2, title: "Create Ticket", description: "Tap 'Create Ticket' button")
            GuideStepView(stepNumber: 3, title: "Fill Details", description: "Enter seat, time, and date")
            GuideStepView(stepNumber: 4, title: "Get QR Code", description: "Your ticket with QR code is ready!")
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 40)
    }
}

struct GuideStepView: View {
    let stepNumber: Int
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(Color.gold)
                .frame(width: 32, height: 32)
                .overlay(
                    Text("\(stepNumber)")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gold.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Privacy Policy")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Your Privacy Matters")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.gold)
                        
                        Text("My Movie Vault is designed with privacy in mind. All your data is stored locally on your device.")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text("• No personal information collected\n• Movie data stays on device\n• Photos stored locally\n• No analytics or tracking")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Privacy Policy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundColor(.gold)
                }
            }
        }
    }
}

struct FeedbackView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var feedback = ""
    @State private var showingThankYou = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("Send Feedback")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 20)
                    
                    TextEditor(text: $feedback)
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gold, lineWidth: 1)
                                )
                        )
                        .frame(minHeight: 150)
                    
                    Button("Send Feedback") {
                        showingThankYou = true
                    }
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(feedback.isEmpty ? Color.gray : Color.gold)
                    )
                    .disabled(feedback.isEmpty)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
            .navigationTitle("Feedback")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.gold)
                }
            }
        }
        .alert("Thank You!", isPresented: $showingThankYou) {
            Button("OK") { dismiss() }
        } message: {
            Text("Your feedback has been received!")
        }
    }
}

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.gold.opacity(0.2))
                            .frame(width: 100, height: 100)
                            .overlay(
                                Image(systemName: "film.stack")
                                    .font(.system(size: 50))
                                    .foregroundColor(.gold)
                            )
                        
                        VStack(spacing: 10) {
                            Text("My Movie Vault")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Version 1.0.0")
                                .font(.system(size: 16))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Features")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.gold)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("• Add and manage movie collection")
                                Text("• Create tickets with QR codes")
                                Text("• Share tickets with friends")
                                Text("• Complete privacy - local storage")
                                Text("• Beautiful dark theme")
                            }
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white.opacity(0.05))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.gold.opacity(0.3), lineWidth: 1)
                                )
                        )
                    }
                    .padding(20)
                }
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundColor(.gold)
                }
            }
        }
    }
}
