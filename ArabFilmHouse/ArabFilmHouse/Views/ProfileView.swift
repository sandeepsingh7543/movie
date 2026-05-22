import SwiftUI

struct ProfileView: View {
    @State private var showingSettings = false
    @State private var showingAbout = false
    @State private var showingPrivacy = false
    @State private var showingTerms = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Gradient background
                LinearGradient(
                    colors: [
                        Color.teal.opacity(0.8),
                        Color.blue.opacity(0.6),
                        Color.indigo.opacity(0.4)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    HStack(spacing: 20) {
                        
                    }
                    // Stats
                    HStack(spacing: 40) {
                        StatView(title: "Movies Watched", value: "24")
                        StatView(title: "Watchlist", value: "8")
                        StatView(title: "Reviews", value: "12")
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(20)
                    .padding(.horizontal)
                    
                    // Menu options
                    VStack(spacing: 15) {
                        ProfileMenuRow(
                            icon: "gear",
                            title: "Settings",
                            action: { showingSettings = true }
                        )
                        
                        ProfileMenuRow(
                            icon: "shield",
                            title: "Privacy Policy",
                            action: { showingPrivacy = true }
                        )
                        
                        ProfileMenuRow(
                            icon: "doc.text",
                            title: "Terms of Service",
                            action: { showingTerms = true }
                        )
                        
                        ProfileMenuRow(
                            icon: "questionmark.circle",
                            title: "Help & Support",
                            action: { showingAbout = true }
                        )
                        
                        ProfileMenuRow(
                            icon: "info.circle",
                            title: "About",
                            action: { showingAbout = true }
                        )
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // App version
                    Text("Arab Film House v1.0")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                        .padding(.bottom)
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        .sheet(isPresented: $showingAbout) {
            AboutView()
        }
        .sheet(isPresented: $showingPrivacy) {
            PrivacyPolicyView()
        }
        .sheet(isPresented: $showingTerms) {
            TermsOfServiceView()
        }
    }
    
    private func rateApp() {
        // This would open the App Store rating page
        // For now, it's just a placeholder
    }
}

struct StatView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 5) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
        }
    }
}

struct ProfileMenuRow: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.white)
                    .frame(width: 30)
                
                Text(title)
                    .font(.body)
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
            }
            .padding()
            .background(Color.white.opacity(0.05))
            .cornerRadius(12)
        }
    }
}

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var notificationsEnabled = true
    @State private var selectedQuality = "HD"
    
    let qualityOptions = ["SD", "HD", "4K"]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Notifications
                    SettingToggleRow(
                        title: "Push Notifications",
                        subtitle: "Get notified about new releases",
                        isOn: $notificationsEnabled
                    )
                }
                .padding()
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.white)
            )
        }
    }
}

struct SettingToggleRow: View {
    let title: String
    let subtitle: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .toggleStyle(SwitchToggleStyle(tint: .blue))
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}

struct AboutView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // App icon
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                LinearGradient(
                                    colors: [Color.blue, Color.purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 100, height: 100)
                        
                        Image(systemName: "film.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                    }
                    
                    VStack(spacing: 10) {
                        Text("Arab Film House")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Version 1.0")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Text("Arab Film House is a personal movie tracking app where you can catalog and organize your favorite Arab films. Add movies manually to create your own curated collection and keep track of what you want to watch.")
                        .font(.body)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal)
                    
                    VStack(spacing: 15) {
                        Text("Contact Us")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Text("support@arabfilmhouse.com")
                            .font(.body)
                            .foregroundColor(.blue)
                    }
                    
                    Spacer()
                    
                    Text("© 2024 Arab Film House. All rights reserved.")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                        .multilineTextAlignment(.center)
                }
                .padding()
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.white)
            )
        }
    }
}

#Preview {
    ProfileView()
}
