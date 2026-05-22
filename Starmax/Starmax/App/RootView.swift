import SwiftUI

struct RootView: View {
    @Environment(\.colorScheme) private var systemColorScheme
    @AppStorage("starmax.themeMode") private var themeModeRaw = ThemeMode.dark.rawValue
    @AppStorage("starmax.accentTheme") private var accentThemeRaw = AppThemeStyle.obsidian.rawValue

    private var themeMode: ThemeMode {
        ThemeMode(rawValue: themeModeRaw) ?? .dark
    }

    private var accentTheme: AppThemeStyle {
        AppThemeStyle(rawValue: accentThemeRaw) ?? .obsidian
    }

    private var resolvedColorScheme: ColorScheme? {
        switch themeMode {
        case .dark:
            return .dark
        case .light:
            return .light
        case .system:
            return systemColorScheme
        }
    }

    private var palette: StarmaxPalette {
        StarmaxPalette(isDark: resolvedColorScheme != .light, accentTheme: accentTheme)
    }

    var body: some View {
        ZStack {
            StarmaxBackground()
                .ignoresSafeArea()

            TabView {
                NavigationStack {
                    LibraryView()
                }
                .tabItem {
                    Label("Library", systemImage: "rectangle.grid.2x2")
                }

                NavigationStack {
                    DiscoverView()
                }
                .tabItem {
                    Label("Discover", systemImage: "sparkles")
                }

                NavigationStack {
                    StatsView()
                }
                .tabItem {
                    Label("Stats", systemImage: "chart.bar.xaxis")
                }

                NavigationStack {
                    SettingsView()
                }
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
            }
            .tint(accentTheme.accentColor)
        }
        .preferredColorScheme(themeMode.colorScheme)
        .environment(\.starmaxPalette, palette)
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
