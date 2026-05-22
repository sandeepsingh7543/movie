//
//  SettingsView.swift
//  MovieApppss
//
//  Enhanced Settings View
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var dataManager = DataManager.shared
    @StateObject private var appEnvironment = AppEnvironmentManager.shared
    @State private var showingExportSheet = false
    @State private var showingImportSheet = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Statistics Section
                StatisticsSection()
                
                // Appearance Section
                AppearanceSection()
                
                // Data Management Section
                DataManagementSection(
                    showingExportSheet: $showingExportSheet,
                    showingImportSheet: $showingImportSheet,
                    showingDeleteAlert: $showingDeleteAlert
                )
                
                // About Section
                AboutSection()
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 100)
        }
        .background(Color.clear)
        .sheet(isPresented: $showingExportSheet) {
            ExportDataView()
        }
        .sheet(isPresented: $showingImportSheet) {
            ImportDataView()
        }
        .alert("Delete All Data", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteAllData()
            }
        } message: {
            Text("This will permanently delete all your movies, actors, and watchlist data. This action cannot be undone.")
        }
    }
    
    private func deleteAllData() {
        dataManager.movies.removeAll()
        dataManager.actors.removeAll()
        dataManager.watchlist.removeAll()
        dataManager.favorites.removeAll()
        
        // Clear UserDefaults
        UserDefaults.standard.removeObject(forKey: "SavedMovies")
        UserDefaults.standard.removeObject(forKey: "SavedActors")
        UserDefaults.standard.removeObject(forKey: "SavedWatchlist")
        UserDefaults.standard.removeObject(forKey: "SavedFavorites")
    }
}

struct StatisticsSection: View {
    @StateObject private var dataManager = DataManager.shared
    @State private var showingDetailedStats = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Statistics")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button("View Details") {
                    showingDetailedStats = true
                }
                .font(.caption)
                .foregroundColor(.blue)
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                StatCardSettings(
                    icon: "film.fill",
                    title: "Total Movies",
                    value: "\(dataManager.movies.count)",
                    color: .purple
                )
                
                StatCardSettings(
                    icon: "person.2.fill",
                    title: "Total Actors",
                    value: "\(dataManager.actors.count)",
                    color: .blue
                )
                
                StatCardSettings(
                    icon: "checkmark.circle.fill",
                    title: "Watched",
                    value: "\(dataManager.getWatchedMoviesCount())",
                    color: .green
                )
                
                StatCardSettings(
                    icon: "bookmark.fill",
                    title: "Watchlist",
                    value: "\(dataManager.watchlist.count)",
                    color: .orange
                )
                
                StatCardSettings(
                    icon: "heart.fill",
                    title: "Favorites",
                    value: "\(dataManager.favorites.count)",
                    color: .red
                )
                
                StatCardSettings(
                    icon: "clock.fill",
                    title: "Watch Time",
                    value: dataManager.getTotalWatchTime(),
                    color: .cyan
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
        .sheet(isPresented: $showingDetailedStats) {
            StatisticsView()
        }
    }
}

struct StatCardSettings: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct AppearanceSection: View {
    @StateObject private var appEnvironment = AppEnvironmentManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Appearance")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
            
            VStack(spacing: 12) {
                SettingsRow(
                    icon: "paintbrush.fill",
                    title: "Theme",
                    subtitle: appEnvironment.selectedTheme.rawValue,
                    color: .purple
                ) {
                    // Theme selection logic
                }
                
                SettingsRow(
                    icon: "square.grid.2x2",
                    title: "Default View Mode",
                    subtitle: appEnvironment.viewMode.rawValue,
                    color: .blue
                ) {
                    appEnvironment.viewMode = appEnvironment.viewMode == .grid ? .list : .grid
                }
                
                SettingsRow(
                    icon: "arrow.up.arrow.down",
                    title: "Default Sort",
                    subtitle: appEnvironment.sortOption.rawValue,
                    color: .green
                ) {
                    // Sort option selection logic
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

struct DataManagementSection: View {
    @Binding var showingExportSheet: Bool
    @Binding var showingImportSheet: Bool
    @Binding var showingDeleteAlert: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Data Management")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
            
            VStack(spacing: 12) {
                SettingsRow(
                    icon: "square.and.arrow.up",
                    title: "Export Data",
                    subtitle: "Backup your collection",
                    color: .blue
                ) {
                    showingExportSheet = true
                }
                
                SettingsRow(
                    icon: "square.and.arrow.down",
                    title: "Import Data",
                    subtitle: "Restore from backup",
                    color: .green
                ) {
                    showingImportSheet = true
                }
                
                SettingsRow(
                    icon: "trash.fill",
                    title: "Delete All Data",
                    subtitle: "Clear everything",
                    color: .red
                ) {
                    showingDeleteAlert = true
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

struct AboutSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("About")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
            
            VStack(spacing: 12) {
                SettingsRow(
                    icon: "info.circle.fill",
                    title: "Version",
                    subtitle: "1.0.0",
                    color: .gray
                ) { }
                
                SettingsRow(
                    icon: "star.fill",
                    title: "Rate App",
                    subtitle: "Show your support",
                    color: .yellow
                ) {
                    // Rate app logic
                }
                
                SettingsRow(
                    icon: "envelope.fill",
                    title: "Contact Support",
                    subtitle: "Get help",
                    color: .cyan
                ) {
                    // Contact support logic
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                    
                    Text(subtitle)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 12)
        }
    }
}

struct ExportDataView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var dataManager = DataManager.shared
    @State private var showingShareSheet = false
    @State private var exportData: Data?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                VStack(spacing: 12) {
                    Text("Export Your Data")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Create a backup of all your movies, actors, and watchlist data.")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                Button(action: {
                    exportData = dataManager.exportData()
                    showingShareSheet = true
                }) {
                    Text("Export Data")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.blue)
                        )
                }
                .padding(.horizontal, 40)
                
                Spacer()
            }
            .padding(.top, 40)
            .background(Color.black)
            .navigationTitle("Export Data")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
        .sheet(isPresented: $showingShareSheet) {
            if let data = exportData {
                ShareSheet(activityItems: [data])
            }
        }
    }
}

struct ImportDataView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Image(systemName: "square.and.arrow.down")
                    .font(.system(size: 60))
                    .foregroundColor(.green)
                
                VStack(spacing: 12) {
                    Text("Import Your Data")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Restore your collection from a previously exported backup file.")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                Button(action: {
                    // Import logic
                }) {
                    Text("Select Backup File")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.green)
                        )
                }
                .padding(.horizontal, 40)
                
                Spacer()
            }
            .padding(.top, 40)
            .background(Color.black)
            .navigationTitle("Import Data")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    SettingsView()
}
