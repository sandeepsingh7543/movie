import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Privacy Policy")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Last updated: February 2024")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                        
                        Group {
                            privacySection(
                                title: "Information We Collect",
                                content: "Arab Film House does not collect personal information. We only store your movie preferences locally on your device."
                            )
                            
                            privacySection(
                                title: "How We Use Information",
                                content: "Any data stored is used solely to enhance your movie browsing experience and is never shared with third parties."
                            )
                            
                            privacySection(
                                title: "Data Security",
                                content: "All data is stored locally on your device and is protected by iOS security measures."
                            )
                            
                            privacySection(
                                title: "Contact Us",
                                content: "If you have questions about this Privacy Policy, contact us at privacy@arabfilmhouse.com"
                            )
                        }
                    }
                    .padding()
                }
            }
            .navigationBarItems(
                trailing: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.white)
            )
        }
    }
    
    private func privacySection(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            
            Text(content)
                .font(.body)
                .foregroundColor(.white.opacity(0.8))
                .lineSpacing(4)
        }
    }
}

struct TermsOfServiceView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Terms of Service")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Last updated: February 2024")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                        
                        Group {
                            termsSection(
                                title: "Acceptance of Terms",
                                content: "By using Arab Film House, you agree to these terms of service."
                            )
                            
                            termsSection(
                                title: "Use of Service",
                                content: "This app is for personal, non-commercial use only. You may browse movie information and manage your personal watchlist."
                            )
                            
                            termsSection(
                                title: "Content",
                                content: "All movie information is provided for informational purposes only. We do not host or stream any video content."
                            )
                            
                            termsSection(
                                title: "Limitation of Liability",
                                content: "Arab Film House is provided 'as is' without warranties of any kind."
                            )
                        }
                    }
                    .padding()
                }
            }
            .navigationBarItems(
                trailing: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.white)
            )
        }
    }
    
    private func termsSection(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            
            Text(content)
                .font(.body)
                .foregroundColor(.white.opacity(0.8))
                .lineSpacing(4)
        }
    }
}

#Preview {
    PrivacyPolicyView()
}
