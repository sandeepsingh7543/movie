import SwiftUI

// MARK: - Settings View
struct SettingsView: View {
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("autoPlayTrailers") private var autoPlayTrailers = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                List {
                    preferencesSection
                    aboutSection
                    legalSection
                    disclaimerSection
                }
                .listStyle(.insetGrouped)
                .scrollContentBackground(.hidden)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Settings")
                        .font(.appHeadline)
                        .foregroundColor(.white)
                }
            }
        }
    }

    // MARK: - Sections
    private var preferencesSection: some View {
        Section {
            SettingsToggleRow(icon: "bell.fill", title: "Notifications", isOn: $notificationsEnabled)
            SettingsToggleRow(icon: "play.rectangle.fill", title: "Auto-play Trailers", isOn: $autoPlayTrailers)
        } header: {
            sectionHeader("Preferences")
        }
        .listRowBackground(Color.appSurface)
    }

    private var aboutSection: some View {
        Section {
            SettingsInfoRow(icon: "info.circle.fill", title: "Version", value: "1.0.0")
            SettingsInfoRow(icon: "film.fill", title: "Storage", value: "Local Device")
        } header: {
            sectionHeader("About")
        }
        .listRowBackground(Color.appSurface)
    }

    private var legalSection: some View {
        Section {
            SettingsLinkRow(icon: "hand.raised.fill", title: "Privacy Policy", url: "https://www.privacypolicies.com/live/afcb6e79-1200-4eb8-9a22-c905cca788d0")
            SettingsLinkRow(icon: "doc.text.fill", title: "Terms of Use", url: "https://www.privacypolicies.com/live/ff0df36e-18f0-4740-aaa0-6a0a70a56e49")
        } header: {
            sectionHeader("Legal")
        }
        .listRowBackground(Color.appSurface)
    }

    private var disclaimerSection: some View {
        Section {
            Text("This app stores your personal movie library locally on your device. No data is shared or transmitted externally.")
                .font(.system(size: 12))
                .foregroundColor(.appSecondary)
                .padding(.vertical, 4)
        } header: {
            sectionHeader("Disclaimer")
        }
        .listRowBackground(Color.appSurface)
    }

    private func sectionHeader(_ text: String) -> some View {
        Text(text)
            .font(.appCaption)
            .foregroundColor(.appSecondary)
            .textCase(nil)
    }
}

// MARK: - Row Components
struct SettingsToggleRow: View {
    let icon: String
    let title: String
    @Binding var isOn: Bool

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.appAccent)
                .frame(width: 24)
            Text(title)
                .foregroundColor(.white)
            Spacer()
            Toggle("", isOn: $isOn)
                .tint(.appAccent)
        }
    }
}

struct SettingsInfoRow: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.appAccent)
                .frame(width: 24)
            Text(title).foregroundColor(.white)
            Spacer()
            Text(value).foregroundColor(.appSecondary)
        }
    }
}

struct SettingsLinkRow: View {
    let icon: String
    let title: String
    let url: String

    var body: some View {
        if let link = URL(string: url) {
            Link(destination: link) {
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(.appAccent)
                        .frame(width: 24)
                    Text(title).foregroundColor(.white)
                    Spacer()
                    Image(systemName: "arrow.up.right")
                        .font(.appCaption)
                        .foregroundColor(.appSecondary)
                }
            }
        }
    }
}
