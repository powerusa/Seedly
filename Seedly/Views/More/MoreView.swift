// MoreView.swift
// Seedly

import SwiftUI

struct MoreView: View {
    @AppStorage("temperatureUnit") private var temperatureUnit = "celsius"
    @AppStorage("measurementSystem") private var measurementSystem = "metric"
    @AppStorage("selectedLanguage") private var selectedLanguage = "en"
    @EnvironmentObject var localization: LocalizationManager
    @State private var showLanguagePicker = false
    
    var body: some View {
        NavigationStack {
            List {
                // Garden Section
                Section {
                    NavigationLink(destination: Text(localization.myGardens)) {
                        SettingsRow(icon: "leaf.fill", title: localization.myGardens, color: .green)
                    }
                    NavigationLink(destination: Text(localization.location)) {
                        SettingsRow(icon: "location.fill", title: localization.location, color: .blue)
                    }
                    NavigationLink(destination: Text(localization.climateZone)) {
                        SettingsRow(icon: "globe", title: localization.climateZone, color: .teal)
                    }
                } header: {
                    Text(localization.garden)
                }
                
                // Preferences Section
                Section {
                    Picker(selection: $temperatureUnit) {
                        Text("Celsius (°C)").tag("celsius")
                        Text("Fahrenheit (°F)").tag("fahrenheit")
                    } label: {
                        SettingsRow(icon: "thermometer", title: localization.temperature, color: .orange)
                    }
                    
                    Picker(selection: $measurementSystem) {
                        Text("Metric (cm)").tag("metric")
                        Text("Imperial (in)").tag("imperial")
                    } label: {
                        SettingsRow(icon: "ruler", title: localization.measurements, color: .purple)
                    }
                    
                    Button(action: { showLanguagePicker = true }) {
                        HStack {
                            SettingsRow(icon: "globe", title: localization.language, color: .indigo)
                            Spacer()
                            Text(languageName(for: selectedLanguage))
                                .foregroundStyle(.secondary)
                            Image(systemName: "chevron.right")
                                .font(.caption2)
                                .foregroundStyle(.tertiary)
                        }
                    }
                    .foregroundStyle(.primary)
                } header: {
                    Text(localization.preferences)
                }
                
                // Notifications Section
                Section {
                    NavigationLink(destination: NotificationSettingsView()) {
                        SettingsRow(icon: "bell.fill", title: localization.notifications, color: .red)
                    }
                    NavigationLink(destination: Text(localization.frostAlerts)) {
                        SettingsRow(icon: "thermometer.snowflake", title: localization.frostAlerts, color: .cyan)
                    }
                } header: {
                    Text(localization.alerts)
                }
                
                // About Section
                Section {
                    NavigationLink(destination: Text(localization.aboutSeedly)) {
                        SettingsRow(icon: "info.circle.fill", title: localization.aboutSeedly, color: SeedlyTheme.primaryGreen)
                    }
                    NavigationLink(destination: Text("Privacy Policy")) {
                        SettingsRow(icon: "hand.raised.fill", title: "Privacy Policy", color: .gray)
                    }
                    NavigationLink(destination: Text("Acknowledgments")) {
                        SettingsRow(icon: "heart.fill", title: "Acknowledgments", color: .pink)
                    }
                } header: {
                    Text(localization.aboutSeedly)
                } footer: {
                    VStack(spacing: 8) {
                        Text("Simple Seeds v1.0.0")
                            .font(.system(.caption, design: .rounded))
                        Text("Buy once. Garden forever.")
                            .font(.system(.caption, design: .rounded))
                            .foregroundStyle(SeedlyTheme.accentGreen)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, SeedlyTheme.paddingLarge)
                }
            }
            .navigationTitle(localization.more)
            .sheet(isPresented: $showLanguagePicker) {
                LanguagePickerView(selectedLanguage: $selectedLanguage)
            }
        }
    }
    
    private func languageName(for code: String) -> String {
        PlantLocalization.supportedLanguages.first(where: { $0.code == code })?.nativeName ?? "English"
    }
}

// MARK: - Settings Row

struct SettingsRow: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(color)
                    .frame(width: 28, height: 28)
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.white)
            }
            
            Text(title)
                .font(.system(.body, design: .rounded))
        }
    }
}

// MARK: - Language Picker

struct LanguagePickerView: View {
    @Binding var selectedLanguage: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(PlantLocalization.supportedLanguages) { language in
                    Button(action: {
                        selectedLanguage = language.code
                        LocalizationManager.shared.currentLanguage = language.code
                        dismiss()
                    }) {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(language.nativeName)
                                    .font(.system(.body, design: .rounded, weight: .medium))
                                    .foregroundStyle(.primary)
                                Text(language.name)
                                    .font(.system(.caption, design: .rounded))
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                            
                            if selectedLanguage == language.code {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(SeedlyTheme.primaryGreen)
                                    .font(.body.bold())
                            }
                        }
                    }
                }
            }
            .navigationTitle("Language")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundStyle(SeedlyTheme.primaryGreen)
                }
            }
        }
    }
}

// MARK: - Notification Settings

struct NotificationSettingsView: View {
    @AppStorage("frostAlerts") private var frostAlerts = true
    @AppStorage("heatAlerts") private var heatAlerts = true
    @AppStorage("wateringReminders") private var wateringReminders = true
    @AppStorage("plantingReminders") private var plantingReminders = true
    @AppStorage("harvestReminders") private var harvestReminders = true
    @AppStorage("severeWeather") private var severeWeather = true
    
    var body: some View {
        List {
            Section("Weather Alerts") {
                Toggle("Frost Alerts", isOn: $frostAlerts)
                Toggle("Heat Alerts", isOn: $heatAlerts)
                Toggle("Severe Weather", isOn: $severeWeather)
            }
            
            Section("Reminders") {
                Toggle("Watering Reminders", isOn: $wateringReminders)
                Toggle("Planting Reminders", isOn: $plantingReminders)
                Toggle("Harvest Reminders", isOn: $harvestReminders)
            }
            
            Section {
                HStack {
                    Text("Reminder Time")
                    Spacer()
                    Text("8:00 AM")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle("Notifications")
    }
}

#Preview {
    MoreView()
}
