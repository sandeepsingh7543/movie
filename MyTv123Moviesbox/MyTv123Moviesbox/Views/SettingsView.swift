//
//  SettingsView.swift
//  MyTv123Moviesbox
//
//  Complete settings with working features
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var themeManager = ThemeManager.shared
    @StateObject private var dataManager = MovieDataManager.shared
    @StateObject private var notificationManager = NotificationManager.shared
    @Environment(\.dismiss) private var dismiss
    
    @State private var autoPlay = false
    @State private var downloadQuality = "HD"
    @State private var streamingQuality = "Auto"
    @State private var showAdultContent = false
    @State private var dataUsage = "Normal"
    
    let qualityOptions = ["SD", "HD", "4K", "Auto"]
    let dataUsageOptions = ["Low", "Normal", "High"]
    
    var body: some View {
        NavigationView {
            List {
                // App Preferences
                Section("App Preferences") {
                    HStack {
                        Image(systemName: "bell.fill")
                            .foregroundColor(themeManager.accentColor)
                            .frame(width: 25)
                        
                        Toggle("Notifications", isOn: $notificationManager.isEnabled)
                            .onChange(of: notificationManager.isEnabled) { enabled in
                                if enabled {
                                    notificationManager.requestPermission()
                                }
                            }
                    }
                }
                
                // Playback & Quality
                Section("Playback & Quality") {
                    HStack {
                        Image(systemName: "arrow.down.circle.fill")
                            .foregroundColor(themeManager.accentColor)
                            .frame(width: 25)
                        
                        VStack(alignment: .leading) {
                            Text("Download Quality")
                            Text(downloadQuality)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Picker("Download Quality", selection: $downloadQuality) {
                            ForEach(qualityOptions, id: \.self) { quality in
                                Text(quality).tag(quality)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    
                    HStack {
                        Image(systemName: "wifi")
                            .foregroundColor(themeManager.accentColor)
                            .frame(width: 25)
                        
                        VStack(alignment: .leading) {
                            Text("Streaming Quality")
                            Text(streamingQuality)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Picker("Streaming Quality", selection: $streamingQuality) {
                            ForEach(qualityOptions, id: \.self) { quality in
                                Text(quality).tag(quality)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    
                    HStack {
                        Image(systemName: "chart.bar.fill")
                            .foregroundColor(themeManager.accentColor)
                            .frame(width: 25)
                        
                        VStack(alignment: .leading) {
                            Text("Data Usage")
                            Text(dataUsage)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Picker("Data Usage", selection: $dataUsage) {
                            ForEach(dataUsageOptions, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                }
                
                // Theme Settings
                Section("Appearance") {
                    HStack {
                        Image(systemName: "paintbrush.fill")
                            .foregroundColor(themeManager.accentColor)
                            .frame(width: 25)
                        
                        VStack(alignment: .leading) {
                            Text("Theme")
                            Text(themeManager.currentTheme.rawValue)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Picker("Theme", selection: $themeManager.currentTheme) {
                            ForEach(ThemeManager.AppTheme.allCases, id: \.self) { theme in
                                Text(theme.rawValue).tag(theme)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .onChange(of: themeManager.currentTheme) { newTheme in
                            themeManager.setTheme(newTheme)
                        }
                    }
                }
                
                // About
                Section("About") {
                    HStack {
                        Image(systemName: "film.fill")
                            .foregroundColor(themeManager.accentColor)
                            .frame(width: 25)
                        
                        VStack(alignment: .leading) {
                            Text("App Name")
                            Text("MyTv123 Moviesbox")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(themeManager.accentColor)
                            .frame(width: 25)
                        
                        VStack(alignment: .leading) {
                            Text("Version")
                            Text("1.0.0 (Build 1)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(themeManager.accentColor)
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
