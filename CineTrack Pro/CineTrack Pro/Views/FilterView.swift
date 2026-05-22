//
//  FilterView.swift
//  CineTrack Pro
//
//  Created by Mobi iOS on 31/03/26.
//

import SwiftUI

struct FilterView: View {
    @ObservedObject var viewModel: MovieViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var selectedGenre: MovieGenre?
    @State private var selectedStatus: WatchStatus?

    init(viewModel: MovieViewModel) {
        self.viewModel = viewModel
        _selectedGenre = State(initialValue: viewModel.selectedGenre)
        _selectedStatus = State(initialValue: viewModel.selectedStatus)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    // Genre
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Genre")
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding(.horizontal)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(MovieGenre.allCases, id: \.self) { genre in
                                    genreChip(genre)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }

                    // Watch Status
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Watch Status")
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding(.horizontal)

                        VStack(spacing: 0) {
                            // All option
                            let allSelected = selectedStatus == nil
                            HStack {
                                Image(systemName: "circle.grid.2x2.fill")
                                    .foregroundColor(allSelected ? .yellow : .gray)
                                    .frame(width: 24)
                                Text("All")
                                    .foregroundColor(.primary)
                                Spacer()
                                if allSelected {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.yellow)
                                        .fontWeight(.semibold)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 14)
                            .contentShape(Rectangle())
                            .onTapGesture { selectedStatus = nil }

                            Divider().padding(.leading, 44)

                            ForEach(WatchStatus.allCases, id: \.self) { status in
                                statusRow(status)
                                if status != WatchStatus.allCases.last {
                                    Divider().padding(.leading, 44)
                                }
                            }
                        }
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }

                    // Clear
                    Button {
                        selectedGenre = nil
                        selectedStatus = nil
                    } label: {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                            Text("Clear All Filters")
                        }
                        .foregroundColor(.yellow)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        viewModel.selectedGenre = selectedGenre
                        viewModel.selectedStatus = selectedStatus
                        dismiss()
                    }
                    .foregroundColor(.yellow)
                    .fontWeight(.bold)
                }
            }
        }
    }

    private func genreChip(_ genre: MovieGenre) -> some View {
        let isSelected = selectedGenre == genre
        return Text(genre.rawValue)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundColor(isSelected ? .white : .primary)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? Color.blue : Color(.secondarySystemBackground))
            )
            .onTapGesture {
                selectedGenre = isSelected ? nil : genre
            }
    }

    private func statusRow(_ status: WatchStatus) -> some View {
        let isSelected = selectedStatus == status
        return HStack {
            Image(systemName: status.icon)
                .foregroundColor(status.color)
                .frame(width: 24)
            Text(status.rawValue)
                .foregroundColor(.primary)
            Spacer()
            if isSelected {
                Image(systemName: "checkmark")
                    .foregroundColor(status.color)
                    .fontWeight(.semibold)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 14)
        .contentShape(Rectangle())
        .onTapGesture {
            selectedStatus = isSelected ? nil : status
        }
    }
}

// MARK: - Filter Chip (used in LibraryView)
struct FilterChip: View {
    let text: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? color : Color(.secondarySystemBackground))
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Filter Row (kept for compatibility)
struct FilterRow: View {
    let text: String
    let icon: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(isSelected ? color : .gray)
            Text(text)
                .foregroundColor(.primary)
            Spacer()
            if isSelected {
                Image(systemName: "checkmark")
                    .foregroundColor(color)
            }
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onTapGesture { action() }
    }
}

#Preview {
    FilterView(viewModel: MovieViewModel())
        .preferredColorScheme(.dark)
}
