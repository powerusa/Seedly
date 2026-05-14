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
                    NavigationLink(destination: MyGardenView()) {
                        SettingsRow(icon: "leaf.fill", title: localization.myGardens, color: .green)
                    }
                    NavigationLink(destination: LocationSettingsView()) {
                        SettingsRow(icon: "location.fill", title: localization.location, color: .blue)
                    }
                    NavigationLink(destination: ClimateZoneInfoView()) {
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
                    NavigationLink(destination: FrostAlertsDetailView()) {
                        SettingsRow(icon: "thermometer.snowflake", title: localization.frostAlerts, color: .cyan)
                    }
                } header: {
                    Text(localization.alerts)
                }
                
                // About Section
                Section {
                    NavigationLink(destination: AboutSeedlyView()) {
                        SettingsRow(icon: "info.circle.fill", title: localization.aboutSeedly, color: SeedlyTheme.primaryGreen)
                    }
                    NavigationLink(destination: PrivacyPolicyView()) {
                        SettingsRow(icon: "hand.raised.fill", title: localization.privacyPolicy, color: .gray)
                    }
                    NavigationLink(destination: AcknowledgmentsView()) {
                        SettingsRow(icon: "heart.fill", title: localization.acknowledgments, color: .pink)
                    }
                } header: {
                    Text(localization.aboutSeedly)
                } footer: {
                    VStack(spacing: 8) {
                        Text("Simple Seeds v1.0.0")
                            .font(.system(.caption, design: .rounded))
                        Text(localization.appTagline)
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
            .navigationTitle(LocalizationManager.shared.language)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(LocalizationManager.shared.done) { dismiss() }
                        .foregroundStyle(SeedlyTheme.primaryGreen)
                }
            }
        }
    }
}

// MARK: - Notification Settings

struct NotificationSettingsView: View {
    @EnvironmentObject var localization: LocalizationManager
    @AppStorage("frostAlerts") private var frostAlerts = true
    @AppStorage("heatAlerts") private var heatAlerts = true
    @AppStorage("wateringReminders") private var wateringReminders = true
    @AppStorage("plantingReminders") private var plantingReminders = true
    @AppStorage("harvestReminders") private var harvestReminders = true
    @AppStorage("severeWeather") private var severeWeather = true
    
    var body: some View {
        List {
            Section(localization.weatherAlerts) {
                Toggle(localization.frostAlerts, isOn: $frostAlerts)
                Toggle(localization.heatAlerts, isOn: $heatAlerts)
                Toggle(localization.severeWeather, isOn: $severeWeather)
            }
            
            Section(localization.reminders) {
                Toggle(localization.wateringReminders, isOn: $wateringReminders)
                Toggle(localization.plantingReminders, isOn: $plantingReminders)
                Toggle(localization.harvestReminders, isOn: $harvestReminders)
            }
            
            Section {
                HStack {
                    Text(localization.reminderTime)
                    Spacer()
                    Text("8:00 AM")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle(localization.notifications)
    }
}

#Preview {
    MoreView()
}
