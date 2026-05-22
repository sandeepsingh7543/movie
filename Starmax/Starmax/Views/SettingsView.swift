import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = SettingsViewModel()
    @Environment(\.starmaxPalette) private var palette

    @AppStorage("starmax.themeMode") private var themeModeRaw = ThemeMode.dark.rawValue
    @AppStorage("starmax.accentTheme") private var accentThemeRaw = AppThemeStyle.obsidian.rawValue
    @State private var showResetAlert = false
    @State private var showPrivacyPolicy = false

    private var themeMode: ThemeMode {
        ThemeMode(rawValue: themeModeRaw) ?? .dark
    }

    private var accentTheme: AppThemeStyle {
        AppThemeStyle(rawValue: accentThemeRaw) ?? .obsidian
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                header
                appearanceCard
                privacyCard
                dataCard
                aboutCard
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
        .scrollIndicators(.hidden)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
        .alert("Reset Starmax?", isPresented: $showResetAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete Everything", role: .destructive) {
                do {
                    try DataManager.shared.resetAllData(in: modelContext)
                } catch {
                    print("Reset failed: \(error)")
                }
            }
        } message: {
            Text("This removes all local movies, collections, and poster images from this device.")
        }
        .sheet(isPresented: $showPrivacyPolicy) {
            PrivacyPolicyView()
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Settings")
                .font(.largeTitle.weight(.bold))
                .foregroundStyle(palette.textPrimary)
            Text("Manage the app look, reset data, and review the local-only privacy policy.")
                .font(.subheadline)
                .foregroundStyle(palette.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .starmaxCard()
    }

    private var appearanceCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            PremiumSectionHeader("Appearance", subtitle: "Starmax defaults to dark mode for a cinematic experience.")

            Picker("Theme", selection: $themeModeRaw) {
                ForEach(ThemeMode.allCases) { mode in
                    Text(mode.rawValue).tag(mode.rawValue)
                }
            }
            .pickerStyle(.segmented)

            VStack(alignment: .leading, spacing: 10) {
                Text("Accent Theme")
                    .foregroundStyle(palette.textSecondary)
                Picker("Accent Theme", selection: $accentThemeRaw) {
                    ForEach(AppThemeStyle.allCases) { theme in
                        Text(theme.rawValue).tag(theme.rawValue)
                    }
                }
                .pickerStyle(.menu)
            }
        }
        .starmaxCard()
    }

    private var privacyCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            PremiumSectionHeader("Privacy", subtitle: "App Store-safe local-only promise.")

            Text("All your movie data is stored locally on your device and never shared.")
                .foregroundStyle(palette.textPrimary)

            Button {
                showPrivacyPolicy = true
            } label: {
                Label("View Privacy Policy", systemImage: "shield.lefthalf.filled")
                    .font(.subheadline.weight(.semibold))
            }
            .buttonStyle(.borderedProminent)
            .tint(accentTheme.accentColor)
        }
        .starmaxCard()
    }

    private var dataCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            PremiumSectionHeader("Data", subtitle: "Keep your library tidy or start fresh.")

            Button(role: .destructive) {
                showResetAlert = true
            } label: {
                Label("Reset All Data", systemImage: "trash")
                    .font(.subheadline.weight(.semibold))
            }
            .buttonStyle(.bordered)
        }
        .starmaxCard()
    }

    private var aboutCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            PremiumSectionHeader("About")
            Text("Starmax \(viewModel.appVersion())")
                .foregroundStyle(palette.textPrimary)
            Text("Offline-first personal movie library and smart watchlist.")
                .foregroundStyle(palette.textSecondary)
        }
        .starmaxCard()
    }
}
