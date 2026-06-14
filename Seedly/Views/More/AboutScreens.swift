// AboutScreens.swift
// Seedly
// Detail screens reachable from the More tab:
// About Simple Seeds, Privacy Policy, Acknowledgments,
// Location, Climate Zone, Frost Alerts.

import SwiftUI

// MARK: - About Simple Seeds

struct AboutSeedlyView: View {
    @EnvironmentObject var localization: LocalizationManager
    
    private var appVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0.0"
    }
    
    private var buildNumber: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1"
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: SeedlyTheme.paddingLarge) {
                // App icon + name
                VStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 22)
                            .fill(
                                LinearGradient(
                                    colors: [SeedlyTheme.primaryGreen, SeedlyTheme.accentGreen],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 96, height: 96)
                            .shadow(color: SeedlyTheme.primaryGreen.opacity(0.3), radius: 12, y: 6)
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 48, weight: .medium))
                            .foregroundStyle(.white)
                    }
                    
                    Text("Simple Seeds")
                        .font(.system(.title, design: .rounded, weight: .bold))
                    
                    Text(localization.appTagline)
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(SeedlyTheme.accentGreen)
                }
                .padding(.top, SeedlyTheme.paddingLarge)
                
                // Description
                Text(localization.appDescription)
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, SeedlyTheme.paddingLarge)
                
                // Info card
                VStack(spacing: 0) {
                    InfoRow(label: localization.version, value: "\(appVersion) (\(buildNumber))")
                    Divider().padding(.leading)
                    InfoRow(label: localization.language, value: PlantLocalization.supportedLanguages.first(where: { $0.code == localization.currentLanguage })?.nativeName ?? "English")
                }
                .background(
                    RoundedRectangle(cornerRadius: SeedlyTheme.cornerRadius)
                        .fill(Color(.systemBackground))
                )
                .padding(.horizontal, SeedlyTheme.paddingLarge)
                
                Spacer(minLength: SeedlyTheme.paddingLarge)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(localization.aboutSeedly)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Privacy Policy

struct PrivacyPolicyView: View {
    @EnvironmentObject var localization: LocalizationManager
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SeedlyTheme.paddingMedium) {
                HStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray)
                            .frame(width: 44, height: 44)
                        Image(systemName: "hand.raised.fill")
                            .font(.title3)
                            .foregroundStyle(.white)
                    }
                    Text(localization.privacyPolicy)
                        .font(.system(.title2, design: .rounded, weight: .bold))
                }
                .padding(.top, SeedlyTheme.paddingMedium)
                
                Text(localization.privacyPolicyContent)
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(.primary)
                    .lineSpacing(4)
            }
            .padding(SeedlyTheme.paddingLarge)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(localization.privacyPolicy)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Acknowledgments

struct AcknowledgmentsView: View {
    @EnvironmentObject var localization: LocalizationManager
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SeedlyTheme.paddingMedium) {
                HStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.pink)
                            .frame(width: 44, height: 44)
                        Image(systemName: "heart.fill")
                            .font(.title3)
                            .foregroundStyle(.white)
                    }
                    Text(localization.acknowledgments)
                        .font(.system(.title2, design: .rounded, weight: .bold))
                }
                .padding(.top, SeedlyTheme.paddingMedium)
                
                Text(localization.acknowledgmentsContent)
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(.primary)
                    .lineSpacing(4)
            }
            .padding(SeedlyTheme.paddingLarge)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(localization.acknowledgments)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Location Settings

struct LocationSettingsView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var localization: LocalizationManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: SeedlyTheme.paddingMedium) {
                // Map-style hero
                ZStack {
                    RoundedRectangle(cornerRadius: SeedlyTheme.cornerRadius)
                        .fill(
                            LinearGradient(
                                colors: [.blue.opacity(0.6), .cyan.opacity(0.4)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 140)
                    Image(systemName: "location.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(.white)
                        .shadow(radius: 4)
                }
                .padding(.horizontal, SeedlyTheme.paddingLarge)
                .padding(.top, SeedlyTheme.paddingMedium)
                
                // Current location card
                if let loc = appState.currentLocation {
                    VStack(spacing: 0) {
                        InfoRow(label: "📍", value: "\(loc.city), \(loc.country)")
                        Divider().padding(.leading)
                        InfoRow(label: localization.latitude, value: String(format: "%.4f°", loc.latitude))
                        Divider().padding(.leading)
                        InfoRow(label: localization.longitude, value: String(format: "%.4f°", loc.longitude))
                        Divider().padding(.leading)
                        InfoRow(label: "🌐", value: loc.timeZone.identifier)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: SeedlyTheme.cornerRadius)
                            .fill(Color(.systemBackground))
                    )
                    .padding(.horizontal, SeedlyTheme.paddingLarge)
                } else {
                    VStack(spacing: 8) {
                        Image(systemName: "location.slash")
                            .font(.title)
                            .foregroundStyle(.secondary)
                        Text(localization.locationNotAvailable)
                            .font(.system(.body, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, SeedlyTheme.paddingLarge)
                    .background(
                        RoundedRectangle(cornerRadius: SeedlyTheme.cornerRadius)
                            .fill(Color(.systemBackground))
                    )
                    .padding(.horizontal, SeedlyTheme.paddingLarge)
                }
                
                // Refresh button
                Button(action: {
                    appState.refreshLocation()
                }) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text(localization.refreshLocation)
                    }
                    .font(.system(.body, design: .rounded, weight: .medium))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: SeedlyTheme.cornerRadius)
                            .fill(SeedlyTheme.primaryGreen)
                    )
                }
                .padding(.horizontal, SeedlyTheme.paddingLarge)
                
                // Privacy note
                Text(localization.locationDescription)
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, SeedlyTheme.paddingLarge)
                    .padding(.top, SeedlyTheme.paddingSmall)
                
                Spacer(minLength: SeedlyTheme.paddingLarge)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(localization.location)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Climate Zone Info

struct ClimateZoneInfoView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var localization: LocalizationManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: SeedlyTheme.paddingMedium) {
                // Hero
                ZStack {
                    RoundedRectangle(cornerRadius: SeedlyTheme.cornerRadius)
                        .fill(
                            LinearGradient(
                                colors: [Color.teal, Color.green.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 140)
                    VStack(spacing: 4) {
                        Image(systemName: "globe")
                            .font(.system(size: 40))
                            .foregroundStyle(.white)
                        if let zone = appState.climateZone {
                            Text(zone.koppenClass.rawValue)
                                .font(.system(.title, design: .rounded, weight: .bold))
                                .foregroundStyle(.white)
                        }
                    }
                }
                .padding(.horizontal, SeedlyTheme.paddingLarge)
                .padding(.top, SeedlyTheme.paddingMedium)
                
                if let zone = appState.climateZone {
                    VStack(spacing: 0) {
                        InfoRow(label: localization.climateZone, value: zone.koppenClass.description)
                        Divider().padding(.leading)
                        if let usda = zone.usdaZone {
                            InfoRow(label: "USDA", value: usda)
                            Divider().padding(.leading)
                        }
                        InfoRow(label: localization.growingSeason, value: "\(zone.growingSeasonWeeks) \(localization.weeks)")
                        Divider().padding(.leading)
                        if let last = zone.averageLastFrost {
                            InfoRow(label: localization.lastFrost, value: formatMonthWeek(last))
                            Divider().padding(.leading)
                        }
                        if let first = zone.averageFirstFrost {
                            InfoRow(label: localization.firstFrost, value: formatMonthWeek(first))
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: SeedlyTheme.cornerRadius)
                            .fill(Color(.systemBackground))
                    )
                    .padding(.horizontal, SeedlyTheme.paddingLarge)
                } else {
                    Text(localization.locationNotAvailable)
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(.secondary)
                        .padding(.top, SeedlyTheme.paddingLarge)
                }
                
                Text(localization.climateZoneDescription)
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, SeedlyTheme.paddingLarge)
                    .padding(.top, SeedlyTheme.paddingSmall)
                
                Spacer(minLength: SeedlyTheme.paddingLarge)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(localization.climateZone)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func formatMonthWeek(_ mw: MonthWeek) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: localization.currentLanguage)
        let symbols = formatter.standaloneMonthSymbols ?? []
        let monthName = (mw.month >= 1 && mw.month <= symbols.count) ? symbols[mw.month - 1] : "—"
        return "\(monthName.prefix(1).localizedCapitalized + monthName.dropFirst()) (≈ \(localization.weeks.prefix(0))\(mw.week))"
    }
}

// MARK: - Frost Alerts Detail

struct FrostAlertsDetailView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var localization: LocalizationManager
    @AppStorage("frostAlerts") private var frostAlertsEnabled = true
    
    var body: some View {
        List {
            Section {
                Toggle(localization.frostAlerts, isOn: $frostAlertsEnabled)
            }
            
            if let zone = appState.climateZone {
                Section(localization.climateZone) {
                    if let last = zone.averageLastFrost {
                        InfoRow(label: localization.lastFrost, value: formatMonthWeek(last))
                            .listRowInsets(EdgeInsets())
                    }
                    if let first = zone.averageFirstFrost {
                        InfoRow(label: localization.firstFrost, value: formatMonthWeek(first))
                            .listRowInsets(EdgeInsets())
                    }
                    InfoRow(label: localization.growingSeason, value: "\(zone.growingSeasonWeeks) \(localization.weeks)")
                        .listRowInsets(EdgeInsets())
                }
            }
        }
        .navigationTitle(localization.frostAlerts)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func formatMonthWeek(_ mw: MonthWeek) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: localization.currentLanguage)
        let symbols = formatter.standaloneMonthSymbols ?? []
        let monthName = (mw.month >= 1 && mw.month <= symbols.count) ? symbols[mw.month - 1] : "—"
        return "\(monthName.prefix(1).localizedCapitalized + monthName.dropFirst())"
    }
}

// MARK: - Shared Info Row

private struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.primary)
            Spacer()
            Text(value)
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, SeedlyTheme.paddingMedium)
        .padding(.vertical, 14)
    }
}
