//
//  SettingsView.swift
//  CineTrack Pro
//
//  Created by Mobi iOS on 31/03/26.
//

import SwiftUI
import UniformTypeIdentifiers

struct ExportFile: Identifiable {
    let id = UUID()
    let data: Data
}

struct SettingsView: View {
    @ObservedObject var viewModel: MovieViewModel
    @State private var showingImportPicker = false
    @State private var showingClearDataAlert = false
    @State private var exportData: ExportFile?

    var body: some View {
        NavigationStack {
            Form {
                Section("Appearance") {
                    HStack {
                        Image(systemName: "moon.fill")
                            .foregroundColor(.yellow)
                        Text("Dark Mode")
                            .foregroundColor(.primary)
                        Spacer()
                        Toggle("", isOn: $viewModel.isDarkMode)
                            .toggleStyle(SwitchToggleStyle(tint: .yellow))
                    }
                }

                Section("Statistics") {
                    StatisticRow(title: "Total Movies", value: "\(viewModel.totalMovies)", icon: "film.fill")
                    StatisticRow(title: "Movies Watched", value: "\(viewModel.watchedCount)", icon: "checkmark.circle.fill")
                    StatisticRow(title: "Average Rating", value: String(format: "%.1f", viewModel.averageRating), icon: "star.fill")
                    StatisticRow(title: "Plan to Watch", value: "\(viewModel.movies.filter { $0.watchStatus == .planToWatch }.count)", icon: "bookmark.fill")
                    StatisticRow(title: "Currently Watching", value: "\(viewModel.movies.filter { $0.watchStatus == .watching }.count)", icon: "play.fill")
                }

                Section("Backup & Restore") {
                    Button {
                        exportMovies()
                    } label: {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(.yellow)
                            Text("Export Movies")
                                .foregroundColor(.primary)
                        }
                    }

                    Button {
                        showingImportPicker = true
                    } label: {
                        HStack {
                            Image(systemName: "square.and.arrow.down")
                                .foregroundColor(.yellow)
                            Text("Import Movies")
                                .foregroundColor(.primary)
                        }
                    }
                }

                Section("Data Management") {
                    Button {
                        viewModel.restoreSampleData()
                    } label: {
                        HStack {
                            Image(systemName: "sparkles")
                                .foregroundColor(.yellow)
                            Text("Restore Sample Data")
                                .foregroundColor(.primary)
                        }
                    }

                    Button {
                        showingClearDataAlert = true
                    } label: {
                        HStack {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                            Text("Clear All Data")
                                .foregroundColor(.red)
                        }
                    }
                }

                Section("About") {
                    HStack {
                        Image(systemName: "info.circle")
                            .foregroundColor(.yellow)
                        VStack(alignment: .leading) {
                            Text("CineTrack Pro")
                                .foregroundColor(.primary)
                                .fontWeight(.medium)
                            Text("Version 1.0.0")
                                .foregroundColor(.secondary)
                                .font(.caption)
                        }
                        Spacer()
                    }

                    HStack {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                        Text("Made with love for movie enthusiasts")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .background(Color(.systemGroupedBackground))
            .scrollContentBackground(.hidden)
        }
        .onChange(of: viewModel.isDarkMode) { _, _ in
            viewModel.saveDarkMode()
        }
        .sheet(item: $exportData) { file in
            ShareSheet(items: [file.data])
        }
        .fileImporter(
            isPresented: $showingImportPicker,
            allowedContentTypes: [UTType.json],
            allowsMultipleSelection: false
        ) { result in
            handleImport(result: result)
        }
        .alert("Clear All Data", isPresented: $showingClearDataAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Clear", role: .destructive) {
                viewModel.clearAllData()
            }
        } message: {
            Text("This will permanently delete all your movies and data. This action cannot be undone.")
        }
    }

    private func exportMovies() {
        if let data = viewModel.exportMovies() {
            exportData = ExportFile(data: data)
        }
    }

    private func handleImport(result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            guard let url = urls.first else { return }
            do {
                let data = try Data(contentsOf: url)
                _ = viewModel.importMovies(from: data)
            } catch {}
        case .failure:
            break
        }
    }
}

// MARK: - Statistic Row
struct StatisticRow: View {
    let title: String
    let value: String
    let icon: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.yellow)
                .frame(width: 20)
            Text(title)
                .foregroundColor(.primary)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
                .fontWeight(.medium)
        }
    }
}

// MARK: - Share Sheet
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    SettingsView(viewModel: MovieViewModel())
        .preferredColorScheme(.dark)
}
