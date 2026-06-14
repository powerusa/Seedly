// TodayView.swift
// Seedly

import SwiftUI

struct TodayView: View {
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var localization: LocalizationManager
    @State private var animateBackground = false
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    headerSection
                    weatherSection
                    insightsSection
                    plantingRecommendationsSection
                    frostForecastSection
                }
                .padding(.bottom, 100)
            }
            .background(backgroundGradient)
            .ignoresSafeArea(edges: .top)
            .task {
                appState.refreshLocation()
                await appState.refreshWeather()
                await viewModel.loadData(location: appState.currentLocation, weather: appState.currentWeather)
            }
            .refreshable {
                appState.refreshLocation()
                await appState.refreshWeather()
                await viewModel.loadData(location: appState.currentLocation, weather: appState.currentWeather)
            }
            .onChange(of: appState.currentLocation) { _, location in
                Task {
                    await appState.refreshWeather()
                    await viewModel.loadData(location: location, weather: appState.currentWeather)
                }
            }
            .onReceive(appState.$currentWeather) { weather in
                Task {
                    await viewModel.loadData(location: appState.currentLocation, weather: weather)
                }
            }
        }
    }
    
    // MARK: - Background
    private var backgroundGradient: some View {
        ZStack {
            SeedlyTheme.homeGradient
                .ignoresSafeArea()
            
            // Animated particles
            GeometryReader { geo in
                ForEach(0..<6) { i in
                    Circle()
                        .fill(Color.white.opacity(0.03))
                        .frame(width: CGFloat.random(in: 50...150))
                        .offset(
                            x: CGFloat.random(in: 0...geo.size.width),
                            y: animateBackground ?
                                CGFloat.random(in: 0...geo.size.height) :
                                CGFloat.random(in: 0...geo.size.height) + 20
                        )
                        .animation(
                            .easeInOut(duration: Double.random(in: 4...8))
                            .repeatForever(autoreverses: true)
                            .delay(Double(i) * 0.5),
                            value: animateBackground
                        )
                }
            }
            .onAppear { animateBackground = true }
        }
    }
    
    // MARK: - Header
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(localization.todayInYourGarden)
                        .font(.system(.title2, design: .rounded, weight: .bold))
                        .foregroundStyle(.white)
                    
                    if let location = viewModel.location {
                        HStack(spacing: 4) {
                            Image(systemName: "location.fill")
                                .font(.caption2)
                            Text("\(location.city), \(location.country)")
                                .font(.system(.caption, design: .rounded))
                            
                            if let zone = viewModel.climateZone {
                                Text("•")
                                Text("USDA Zone \(zone.usdaZone ?? "?")")
                                    .font(.system(.caption, design: .rounded))
                            }
                        }
                        .foregroundStyle(.white.opacity(0.7))
                    }
                }
                
                Spacer()
                
                // Seedly Logo
                ZStack {
                    Circle()
                        .fill(SeedlyTheme.accentGreen.opacity(0.3))
                        .frame(width: 44, height: 44)
                    Image(systemName: "leaf.fill")
                        .font(.title3)
                        .foregroundStyle(.white)
                }
            }
        }
        .padding(.horizontal, SeedlyTheme.paddingLarge)
        .padding(.top, 60)
        .padding(.bottom, SeedlyTheme.paddingMedium)
    }
    
    // MARK: - Weather
    private var weatherSection: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.temperatureString)
                    .font(.system(size: 52, weight: .thin, design: .rounded))
                    .foregroundStyle(.white)
                
                Text(viewModel.weather?.condition.localizedDisplayName ?? localization.loading)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(.white.opacity(0.8))
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(viewModel.highLowString)
                    .font(.system(.subheadline, design: .rounded, weight: .medium))
                    .foregroundStyle(.white.opacity(0.8))
                
                if viewModel.weather?.hasRainExpected == true {
                    Label(localization.rainTomorrow, systemImage: "cloud.rain.fill")
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(SeedlyTheme.rain)
                }
            }
        }
        .padding(.horizontal, SeedlyTheme.paddingLarge)
        .padding(.bottom, SeedlyTheme.paddingLarge)
    }
    
    // MARK: - Insights
    private var insightsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(localization.todaysHighlights)
                .font(.system(.headline, design: .rounded, weight: .semibold))
                .foregroundStyle(.white)
                .padding(.horizontal, SeedlyTheme.paddingLarge)
            
            VStack(spacing: 10) {
                if viewModel.insights.isEmpty {
                    // Default insight cards
                    InsightCardView(
                        icon: "leaf.fill",
                        title: localization.insightPlantingPerfect,
                        color: .green
                    )
                    
                    InsightCardView(
                        icon: "thermometer.snowflake",
                        title: localization.insightFrostRisk,
                        subtitle: localization.insightFrostSubtitle,
                        color: SeedlyTheme.frost
                    )
                    
                    InsightCardView(
                        icon: "cloud.rain.fill",
                        title: localization.insightRainExpected,
                        subtitle: localization.insightRainSubtitle,
                        color: SeedlyTheme.rain
                    )
                    
                    InsightCardView(
                        icon: "house.fill",
                        title: localization.insightStartIndoors,
                        color: .purple
                    )
                } else {
                    ForEach(viewModel.insights) { insight in
                        InsightCardView(
                            icon: insight.icon,
                            title: insight.title,
                            subtitle: insight.subtitle,
                            color: colorForInsight(insight.type)
                        )
                    }
                }
            }
            .padding(.horizontal, SeedlyTheme.paddingLarge)
        }
        .padding(.bottom, SeedlyTheme.paddingLarge)
    }
    
    // MARK: - Planting Recommendations
    private var plantingRecommendationsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(localization.comingUp)
                    .font(.system(.headline, design: .rounded, weight: .semibold))
                    .foregroundStyle(.white)
                Spacer()
                Text(localization.viewAll)
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.white.opacity(0.6))
            }
            .padding(.horizontal, SeedlyTheme.paddingLarge)
            
            VStack(spacing: 8) {
                if let tomato = PlantDatabase.shared.plant(byId: "tomato") {
                    NavigationLink(destination: PlantDetailView(plant: tomato)) {
                        PlantRecommendationRow(
                            plantName: PlantLocalization.localizedName(for: "plant_tomato", locale: localization.currentLanguage),
                            detail: localization.safePlantIn(days: 12),
                            icon: "leaf.fill",
                            color: .green
                        )
                    }
                }
                
                if let pepper = PlantDatabase.shared.plant(byId: "pepper") {
                    NavigationLink(destination: PlantDetailView(plant: pepper)) {
                        PlantRecommendationRow(
                            plantName: PlantLocalization.localizedName(for: "plant_pepper", locale: localization.currentLanguage),
                            detail: localization.safePlantIn(days: 14),
                            icon: "leaf.fill",
                            color: .orange
                        )
                    }
                }
                
                if let basil = PlantDatabase.shared.plant(byId: "basil") {
                    NavigationLink(destination: PlantDetailView(plant: basil)) {
                        PlantRecommendationRow(
                            plantName: PlantLocalization.localizedName(for: "plant_basil", locale: localization.currentLanguage),
                            detail: localization.startIndoorsNow,
                            icon: "house.fill",
                            color: .purple
                        )
                    }
                }
            }
            .padding(.horizontal, SeedlyTheme.paddingLarge)
        }
        .padding(.bottom, SeedlyTheme.paddingLarge)
    }
    
    // MARK: - Frost Forecast
    private var frostForecastSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(localization.frostForecast)
                .font(.system(.headline, design: .rounded, weight: .semibold))
                .foregroundStyle(.white)
                .padding(.horizontal, SeedlyTheme.paddingLarge)
            
            HStack(spacing: 0) {
                ForEach(Array(viewModel.frostForecast.prefix(5).enumerated()), id: \.offset) { index, day in
                    VStack(spacing: 8) {
                        Text(dayName(for: day.date))
                            .font(.system(.caption2, design: .rounded))
                            .foregroundStyle(.white.opacity(0.7))
                        
                        Image(systemName: day.condition.icon)
                            .font(.title3)
                            .foregroundStyle(day.hasFrostRisk ? SeedlyTheme.frost : .white.opacity(0.8))
                        
                        Text("\(Int(day.lowTemp))°")
                            .font(.system(.subheadline, design: .rounded, weight: .medium))
                            .foregroundStyle(day.hasFrostRisk ? SeedlyTheme.frost : .white)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.vertical, SeedlyTheme.paddingMedium)
            .padding(.horizontal, SeedlyTheme.paddingSmall)
            .background(
                RoundedRectangle(cornerRadius: SeedlyTheme.cornerRadius)
                    .fill(.ultraThinMaterial.opacity(0.5))
            )
            .padding(.horizontal, SeedlyTheme.paddingLarge)
            
            if viewModel.weather?.hasFrostRisk == true {
                HStack {
                    Image(systemName: "checkmark.shield.fill")
                        .foregroundStyle(SeedlyTheme.accentGreen)
                    Text(localization.safePlantingMessage)
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.white.opacity(0.7))
                }
                .padding(.horizontal, SeedlyTheme.paddingLarge)
            }
        }
        .padding(.bottom, SeedlyTheme.paddingLarge)
    }
    
    // MARK: - Helpers
    private func colorForInsight(_ type: GardenInsight.InsightType) -> Color {
        switch type {
        case .planting: return .green
        case .frost: return SeedlyTheme.frost
        case .rain: return SeedlyTheme.rain
        case .heat: return SeedlyTheme.heat
        case .harvest: return SeedlyTheme.harvest
        case .watering: return .cyan
        case .wind: return .gray
        case .general: return .purple
        }
    }
    
    private func dayName(for date: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) { return localization.tonight }
        return localization.shortWeekday(for: date)
    }
}

// MARK: - Insight Card View

struct InsightCardView: View {
    let icon: String
    let title: String
    var subtitle: String? = nil
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(color.opacity(0.2))
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(color)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(.subheadline, design: .rounded, weight: .medium))
                    .foregroundStyle(.white)
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.white.opacity(0.6))
                }
            }
            
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: SeedlyTheme.cornerRadiusSmall)
                .fill(color.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: SeedlyTheme.cornerRadiusSmall)
                        .stroke(color.opacity(0.2), lineWidth: 0.5)
                )
        )
    }
}

// MARK: - Plant Recommendation Row

struct PlantRecommendationRow: View {
    let plantName: String
    let detail: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 40, height: 40)
                Image(systemName: icon)
                    .foregroundStyle(color)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(plantName)
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    .foregroundStyle(.white)
                Text(detail)
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.white.opacity(0.6))
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.4))
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: SeedlyTheme.cornerRadiusSmall)
                .fill(.white.opacity(0.05))
        )
    }
}

#Preview {
    TodayView()
        .environmentObject(AppState())
}
