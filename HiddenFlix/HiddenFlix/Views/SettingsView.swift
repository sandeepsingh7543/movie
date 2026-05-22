import SwiftUI

//struct SettingsView: View {
//    @AppStorage("isDarkMode") private var isDarkMode = true
//    @State private var showingFeedback = false
//    @State private var showingPrivacyPolicy = false
//    @State private var showingAbout = false
//    
//    var body: some View {
//        ZStack {
//            Color.black.ignoresSafeArea()
//            
//            ScrollView {
//                VStack(spacing: 24) {
//                    headerSection
//                    
//                    VStack(spacing: 0) {
//                        SettingsRow(
//                            icon: "moon.fill",
//                            title: "Dark Mode",
//                            subtitle: "Toggle dark/light theme",
//                            action: { isDarkMode.toggle() },
//                            trailing: {
//                                Toggle("", isOn: $isDarkMode)
//                                    .labelsHidden()
//                                    .tint(.purple)
//                            }
//                        )
//                        
//                        Divider().background(.gray.opacity(0.3))
//                        
//                        SettingsRow(
//                            icon: "envelope.fill",
//                            title: "Send Feedback",
//                            subtitle: "Help us improve the app",
//                            action: { showingFeedback = true }
//                        )
//                        
//                        Divider().background(.gray.opacity(0.3))
//                        
//                        SettingsRow(
//                            icon: "shield.fill",
//                            title: "Privacy Policy",
//                            subtitle: "How we protect your data",
//                            action: { showingPrivacyPolicy = true }
//                        )
//                        
//                        Divider().background(.gray.opacity(0.3))
//                        
//                        SettingsRow(
//                            icon: "info.circle.fill",
//                            title: "About HiddenFlix",
//                            subtitle: "App version and info",
//                            action: { showingAbout = true }
//                        )
//                    }
//                    .background(.gray.opacity(0.1))
//                    .cornerRadius(12)
//                    
//                    appInfoSection
//                }
//                .padding()
//            }
//        }
//        .sheet(isPresented: $showingFeedback) {
//            FeedbackView()
//        }
//        .sheet(isPresented: $showingPrivacyPolicy) {
//            PrivacyPolicyView()
//        }
//        .sheet(isPresented: $showingAbout) {
//            AboutView()
//        }
//    }
//    
//    private var headerSection: some View {
//        HStack {
//            VStack(alignment: .leading, spacing: 4) {
//                Text("Settings")
//                    .font(.custom("Inter", size: 28).weight(.bold))
//                    .foregroundColor(.white)
//                
//                Text("Customize your experience")
//                    .font(.custom("Inter", size: 16))
//                    .foregroundColor(.gray)
//            }
//            
//            Spacer()
//            
//            Image(systemName: "gearshape.fill")
//                .font(.title2)
//                .foregroundColor(.purple)
//        }
//    }
//    
//    private var appInfoSection: some View {
//        VStack(spacing: 12) {
//            Image(systemName: "film.fill")
//                .font(.system(size: 40))
//                .foregroundColor(.purple)
//            
//            Text("HiddenFlix")
//                .font(.custom("Inter", size: 20).weight(.bold))
//                .foregroundColor(.white)
//            
//            Text("AI Movie World")
//                .font(.custom("Inter", size: 14))
//                .foregroundColor(.gray)
//            
//            Text("Version 1.0.0")
//                .font(.custom("Inter", size: 12))
//                .foregroundColor(.gray)
//        }
//        .padding(.top, 20)
//    }
//}
//
////struct SettingsRow<Trailing: View>: View {
////    let icon: String
////    let title: String
////    let subtitle: String
////    let action: () -> Void
////    let trailing: () -> Trailing
////    
////    init(icon: String, title: String, subtitle: String, action: @escaping () -> Void, @ViewBuilder trailing: @escaping () -> Trailing = { EmptyView() }) {
////        self.icon = icon
////        self.title = title
////        self.subtitle = subtitle
////        self.action = action
////        self.trailing = trailing
////    }
////    
////    var body: some View {
////        Button(action: action) {
////            HStack(spacing: 16) {
////                Image(systemName: icon)
////                    .font(.title3)
////                    .foregroundColor(.purple)
////                    .frame(width: 24)
////                
////                VStack(alignment: .leading, spacing: 2) {
////                    Text(title)
////                        .font(.custom("Inter", size: 16).weight(.medium))
////                        .foregroundColor(.white)
////                    
////                    Text(subtitle)
////                        .font(.custom("Inter", size: 14))
////                        .foregroundColor(.gray)
////                }
////                
////                Spacer()
////                
////                trailing()
////                
////                if trailing() is EmptyView {
////                    Image(systemName: "chevron.right")
////                        .font(.system(size: 14))
////                        .foregroundColor(.gray)
////                }
////            }
////            .padding()
////        }
////        .buttonStyle(PlainButtonStyle())
////    }
////}
//
//struct SettingsRow<Trailing: View>: View {
//    let icon: String
//    let title: String
//    let subtitle: String
//    let action: () -> Void
//    let trailing: () -> Trailing
//
//    init(icon: String, title: String, subtitle: String, action: @escaping () -> Void, @ViewBuilder trailing: @escaping () -> Trailing = { EmptyView() }) {
//        self.icon = icon
//        self.title = title
//        self.subtitle = subtitle
//        self.action = action
//        self.trailing = trailing
//    }
//
//    var body: some View {
//        HStack(spacing: 16) {
//            Image(systemName: icon)
//                .font(.title3)
//                .foregroundColor(.purple)
//                .frame(width: 24)
//
//            VStack(alignment: .leading, spacing: 2) {
//                Text(title)
//                    .font(.custom("Inter", size: 16).weight(.medium))
//                    .foregroundColor(.white)
//
//                Text(subtitle)
//                    .font(.custom("Inter", size: 14))
//                    .foregroundColor(.gray)
//            }
//
//            Spacer()
//
//            trailing()
//
//            if trailing() is EmptyView {
//                Image(systemName: "chevron.right")
//                    .font(.system(size: 14))
//                    .foregroundColor(.gray)
//            }
//        }
//        .padding()
//        .background(Color.gray.opacity(0.1))
//        .cornerRadius(12)
//        .onTapGesture {
//            action()
//        }
//    }
//}
//
//struct FeedbackView: View {
//    @Environment(\.dismiss) private var dismiss
//    @State private var feedbackText = ""
//    @State private var feedbackType = "General"
//    
//    let feedbackTypes = ["General", "Bug Report", "Feature Request", "Improvement"]
//    
//    var body: some View {
//        NavigationView {
//            ZStack {
//                Color.black.ignoresSafeArea()
//                
//                VStack(spacing: 24) {
//                    VStack(alignment: .leading, spacing: 12) {
//                        Text("Feedback Type")
//                            .font(.custom("Inter", size: 16).weight(.medium))
//                            .foregroundColor(.white)
//                        
//                        Picker("Type", selection: $feedbackType) {
//                            ForEach(feedbackTypes, id: \.self) { type in
//                                Text(type).tag(type)
//                            }
//                        }
//                        .pickerStyle(SegmentedPickerStyle())
//                    }
//                    
//                    VStack(alignment: .leading, spacing: 12) {
//                        Text("Your Feedback")
//                            .font(.custom("Inter", size: 16).weight(.medium))
//                            .foregroundColor(.white)
//                        
//                        TextEditor(text: $feedbackText)
//                            .font(.custom("Inter", size: 16))
//                            .foregroundColor(.white)
//                            .frame(height: 200)
//                            .padding()
//                            .background(.gray.opacity(0.1))
//                            .cornerRadius(12)
//                    }
//                    
//                    Button(action: { dismiss() }) {
//                        Text("Send Feedback")
//                            .font(.custom("Inter", size: 18).weight(.semibold))
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity)
//                            .frame(height: 56)
//                            .background(.purple)
//                            .cornerRadius(28)
//                    }
//                    .disabled(feedbackText.isEmpty)
//                    .opacity(feedbackText.isEmpty ? 0.5 : 1.0)
//                    
//                    Spacer()
//                }
//                .padding()
//            }
//            .navigationTitle("Send Feedback")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button("Cancel") {
//                        dismiss()
//                    }
//                    .foregroundColor(.purple)
//                }
//            }
//        }
//    }
//}
//
//struct PrivacyPolicyView: View {
//    @Environment(\.dismiss) private var dismiss
//    
//    var body: some View {
//        NavigationView {
//            ZStack {
//                Color.black.ignoresSafeArea()
//                
//                ScrollView {
//                    VStack(alignment: .leading, spacing: 16) {
//                        Text("Privacy Policy")
//                            .font(.custom("Inter", size: 24).weight(.bold))
//                            .foregroundColor(.white)
//                        
//                        Text("Last updated: \(Date().formatted(date: .abbreviated, time: .omitted))")
//                            .font(.custom("Inter", size: 14))
//                            .foregroundColor(.gray)
//                        
//                        Text("Data Collection")
//                            .font(.custom("Inter", size: 18).weight(.semibold))
//                            .foregroundColor(.white)
//                        
//                        Text("HiddenFlix stores your movie data locally on your device using Core Data. We do not collect or transmit any personal information to external servers.")
//                            .font(.custom("Inter", size: 16))
//                            .foregroundColor(.gray)
//                        
//                        Text("AI Features")
//                            .font(.custom("Inter", size: 18).weight(.semibold))
//                            .foregroundColor(.white)
//                        
//                        Text("Our AI movie generation feature creates content locally on your device. No data is sent to external AI services.")
//                            .font(.custom("Inter", size: 16))
//                            .foregroundColor(.gray)
//                        
//                        Text("Contact")
//                            .font(.custom("Inter", size: 18).weight(.semibold))
//                            .foregroundColor(.white)
//                        
//                        Text("If you have any questions about this Privacy Policy, please contact us through the feedback feature.")
//                            .font(.custom("Inter", size: 16))
//                            .foregroundColor(.gray)
//                    }
//                    .padding()
//                }
//            }
//            .navigationTitle("Privacy Policy")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button("Done") {
//                        dismiss()
//                    }
//                    .foregroundColor(.purple)
//                }
//            }
//        }
//    }
//}
//
//struct AboutView: View {
//    @Environment(\.dismiss) private var dismiss
//    
//    var body: some View {
//        NavigationView {
//            ZStack {
//                Color.black.ignoresSafeArea()
//                
//                VStack(spacing: 24) {
//                    Image(systemName: "film.fill")
//                        .font(.system(size: 80))
//                        .foregroundColor(.purple)
//                    
//                    VStack(spacing: 8) {
//                        Text("HiddenFlix")
//                            .font(.custom("Inter", size: 32).weight(.bold))
//                            .foregroundColor(.white)
//                        
//                        Text("AI Movie World")
//                            .font(.custom("Inter", size: 18))
//                            .foregroundColor(.purple)
//                        
//                        Text("Version 1.0.0")
//                            .font(.custom("Inter", size: 16))
//                            .foregroundColor(.gray)
//                    }
//                    
//                    VStack(spacing: 16) {
//                        Text("Features")
//                            .font(.custom("Inter", size: 20).weight(.semibold))
//                            .foregroundColor(.white)
//                        
//                        VStack(alignment: .leading, spacing: 8) {
//                            FeatureRow(icon: "brain.head.profile", text: "AI Movie Generation")
//                            FeatureRow(icon: "magnifyingglass", text: "Smart Search")
//                            FeatureRow(icon: "heart.fill", text: "Favorites & Watchlist")
//                            FeatureRow(icon: "film.fill", text: "Movie Collection")
//                            FeatureRow(icon: "play.circle.fill", text: "Trailer Support")
//                        }
//                    }
//                    
//                    Spacer()
//                    
//                    Text("Made with ❤️ for movie lovers")
//                        .font(.custom("Inter", size: 14))
//                        .foregroundColor(.gray)
//                }
//                .padding()
//            }
//            .navigationTitle("About")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button("Done") {
//                        dismiss()
//                    }
//                    .foregroundColor(.purple)
//                }
//            }
//        }
//    }
//}
//
//struct FeatureRow: View {
//    let icon: String
//    let text: String
//    
//    var body: some View {
//        HStack(spacing: 12) {
//            Image(systemName: icon)
//                .font(.system(size: 16))
//                .foregroundColor(.purple)
//                .frame(width: 20)
//            
//            Text(text)
//                .font(.custom("Inter", size: 16))
//                .foregroundColor(.white)
//            
//            Spacer()
//        }
//    }
//}
//
//#Preview {
//    SettingsView()
//}

import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = true
    
    @State private var showingFeedback = false
    @State private var showingPrivacyPolicy = false
    @State private var showingAbout = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        headerSection
                        
                        VStack(spacing: 0) {
                            // Dark Mode Toggle
//                            SettingsRow(
//                                icon: "moon.fill",
//                                title: "Dark Mode",
//                                subtitle: "Toggle dark/light theme",
//                                action: { isDarkMode.toggle() },
//                                trailing: {
//                                    Toggle("", isOn: $isDarkMode)
//                                        .labelsHidden()
//                                        .tint(.purple)
//                                }
//                            )
                            
//                            Divider().background(.gray.opacity(0.3))
                            
                            // Send Feedback
                            SettingsRow(
                                icon: "envelope.fill",
                                title: "Send Feedback",
                                subtitle: "Help us improve the app"
                            ) {
                                showingFeedback = true
                            }
                            
                            Divider().background(.gray.opacity(0.3))
                            
                            // Privacy Policy
                            SettingsRow(
                                icon: "shield.fill",
                                title: "Privacy Policy",
                                subtitle: "How we protect your data"
                            ) {
                                showingPrivacyPolicy = true
                            }
                            
                            Divider().background(.gray.opacity(0.3))
                            
                            // About
                            SettingsRow(
                                icon: "info.circle.fill",
                                title: "About CineMind",
                                subtitle: "App version and info"
                            ) {
                                showingAbout = true
                            }
                        }
                        .background(.gray.opacity(0.1))
                        .cornerRadius(12)
                        
                        appInfoSection
                    }
                    .padding()
                }
            }
            .navigationTitle("Settings")
            .navigationBarHidden(true)
            // MARK: - Sheets
            .sheet(isPresented: $showingFeedback) {
                FeedbackView()
            }
            .sheet(isPresented: $showingPrivacyPolicy) {
                PrivacyPolicyView()
            }
            .sheet(isPresented: $showingAbout) {
                AboutView()
            }
        }
    }
    
    // MARK: - Header
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Settings")
                    .font(.custom("Inter", size: 28).weight(.bold))
                    .foregroundColor(.white)
                
                Text("Customize your experience")
                    .font(.custom("Inter", size: 16))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Image(systemName: "gearshape.fill")
                .font(.title2)
                .foregroundColor(.purple)
        }
    }
    
    // MARK: - App Info
    private var appInfoSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "film.fill")
                .font(.system(size: 40))
                .foregroundColor(.purple)
            
            Text("CineMind")
                .font(.custom("Inter", size: 20).weight(.bold))
                .foregroundColor(.white)
            
            Text("AI Movie World")
                .font(.custom("Inter", size: 14))
                .foregroundColor(.gray)
            
            Text("Version 1.0.0")
                .font(.custom("Inter", size: 12))
                .foregroundColor(.gray)
        }
        .padding(.top, 20)
    }
}

// MARK: - Settings Row
struct SettingsRow<Trailing: View>: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    let trailing: () -> Trailing
    
    init(icon: String, title: String, subtitle: String, action: @escaping () -> Void, @ViewBuilder trailing: @escaping () -> Trailing = { EmptyView() }) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.action = action
        self.trailing = trailing
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.purple)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.custom("Inter", size: 16).weight(.medium))
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.custom("Inter", size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            trailing()
            
            if trailing() is EmptyView {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
        .onTapGesture {
            action()
        }
    }
}

// MARK: - Feedback View
struct FeedbackView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var feedbackText = ""
    @State private var feedbackType = "General"
    
    let feedbackTypes = ["General", "Bug Report", "Feature Request", "Improvement"]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Feedback Type")
                            .font(.custom("Inter", size: 16).weight(.medium))
                            .foregroundColor(.white)
                        
                        Picker("Type", selection: $feedbackType) {
                            ForEach(feedbackTypes, id: \.self) { type in
                                Text(type).tag(type)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Your Feedback")
                            .font(.custom("Inter", size: 16).weight(.medium))
                            .foregroundColor(.white)
                        
                        TextEditor(text: $feedbackText)
                            .font(.custom("Inter", size: 16))
                            .foregroundColor(.white)
                            .frame(height: 200)
                            .padding()
                            .background(.gray.opacity(0.1))
                            .cornerRadius(12)
                    }
                    
                    Button(action: { dismiss() }) {
                        Text("Send Feedback")
                            .font(.custom("Inter", size: 18).weight(.semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(.purple)
                            .cornerRadius(28)
                    }
                    .disabled(feedbackText.isEmpty)
                    .opacity(feedbackText.isEmpty ? 0.5 : 1.0)
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Send Feedback")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.purple)
                }
            }
        }
    }
}

// MARK: - Privacy Policy
struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Privacy Policy")
                            .font(.custom("Inter", size: 24).weight(.bold))
                            .foregroundColor(.white)
                        
                        Text("Last updated: \(Date().formatted(date: .abbreviated, time: .omitted))")
                            .font(.custom("Inter", size: 14))
                            .foregroundColor(.gray)
                        
                        Text("Data Collection")
                            .font(.custom("Inter", size: 18).weight(.semibold))
                            .foregroundColor(.white)
                        
                        Text("CineMind stores your movie data locally on your device using Core Data. We do not collect or transmit any personal information to external servers.")
                            .font(.custom("Inter", size: 16))
                            .foregroundColor(.gray)
                        
                        Text("AI Features")
                            .font(.custom("Inter", size: 18).weight(.semibold))
                            .foregroundColor(.white)
                        
                        Text("Our AI movie generation feature creates content locally on your device. No data is sent to external AI services.")
                            .font(.custom("Inter", size: 16))
                            .foregroundColor(.gray)
                        
                        Text("Contact")
                            .font(.custom("Inter", size: 18).weight(.semibold))
                            .foregroundColor(.white)
                        
                        Text("If you have any questions about this Privacy Policy, please contact us through the feedback feature.")
                            .font(.custom("Inter", size: 16))
                            .foregroundColor(.gray)
                    }
                    .padding()
                }
            }
            .navigationTitle("Privacy Policy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundColor(.purple)
                }
            }
        }
    }
}

// MARK: - About View
struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 24) {
                    Image(systemName: "film.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.purple)
                    
                    VStack(spacing: 8) {
                        Text("CineMind")
                            .font(.custom("Inter", size: 32).weight(.bold))
                            .foregroundColor(.white)
                        
                        Text("AI Movie World")
                            .font(.custom("Inter", size: 18))
                            .foregroundColor(.purple)
                        
                        Text("Version 1.0.0")
                            .font(.custom("Inter", size: 16))
                            .foregroundColor(.gray)
                    }
                    
                    VStack(spacing: 16) {
                        Text("Features")
                            .font(.custom("Inter", size: 20).weight(.semibold))
                            .foregroundColor(.white)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            FeatureRow(icon: "brain.head.profile", text: "AI Movie Generation")
                            FeatureRow(icon: "magnifyingglass", text: "Smart Search")
                            FeatureRow(icon: "heart.fill", text: "Favorites & Watchlist")
                            FeatureRow(icon: "film.fill", text: "Movie Collection")
                            FeatureRow(icon: "play.circle.fill", text: "Trailer Support")
                        }
                    }
                    
                    Spacer()
                    
                    Text("Made with ❤️ for movie lovers")
                        .font(.custom("Inter", size: 14))
                        .foregroundColor(.gray)
                }
                .padding()
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundColor(.purple)
                }
            }
        }
    }
}

// MARK: - Feature Row
struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.purple)
                .frame(width: 20)
            
            Text(text)
                .font(.custom("Inter", size: 16))
                .foregroundColor(.white)
            
            Spacer()
        }
    }
}

#Preview {
    SettingsView()
}
