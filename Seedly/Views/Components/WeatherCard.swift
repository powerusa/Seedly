// WeatherCard.swift
// Seedly

import SwiftUI

struct WeatherCardView: View {
    let weather: WeatherData
    let temperatureUnit: TemperatureUnit
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Location and condition
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(weather.location)
                        .font(.system(.subheadline, design: .rounded, weight: .semibold))
                        .foregroundStyle(.white)
                    
                    Text(displayTemperature(weather.currentTemp))
                        .font(.system(size: 44, weight: .thin, design: .rounded))
                        .foregroundStyle(.white)
                    
                    Text(weather.condition.rawValue.camelCaseToWords())
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.white.opacity(0.7))
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Image(systemName: weather.condition.icon)
                        .font(.system(size: 36))
                        .foregroundStyle(.white.opacity(0.8))
                        .symbolRenderingMode(.multicolor)
                    
                    Text("H \(displayTemperature(weather.highTemp))")
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.white.opacity(0.7))
                    Text("L \(displayTemperature(weather.lowTemp))")
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.white.opacity(0.7))
                }
            }
            
            Divider()
                .background(.white.opacity(0.2))
            
            // Quick stats
            HStack(spacing: 16) {
                WeatherStat(icon: "humidity.fill", value: "\(weather.humidity)%", label: "Humidity")
                WeatherStat(icon: "wind", value: "\(Int(weather.windSpeedKmh)) km/h", label: "Wind")
                WeatherStat(icon: "sun.max.fill", value: "\(weather.uvIndex)", label: "UV")
                WeatherStat(icon: "drop.fill", value: "\(weather.precipitationChance)%", label: "Rain")
            }
        }
        .padding(SeedlyTheme.paddingMedium)
        .background(
            RoundedRectangle(cornerRadius: SeedlyTheme.cornerRadius)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.15, green: 0.35, blue: 0.55),
                            Color(red: 0.20, green: 0.40, blue: 0.60)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
    }
    
    private func displayTemperature(_ celsius: Double) -> String {
        let value = temperatureUnit.convert(celsius)
        return "\(Int(value))°"
    }
}

struct WeatherStat: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.7))
            Text(value)
                .font(.system(.caption, design: .rounded, weight: .medium))
                .foregroundStyle(.white)
            Text(label)
                .font(.system(.caption2, design: .rounded))
                .foregroundStyle(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Gardening Condition Badge

struct GardeningConditionBadge: View {
    let condition: GardeningImpact
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(conditionColor)
                .frame(width: 8, height: 8)
            Text(condition.rawValue.capitalized)
                .font(.system(.caption, design: .rounded, weight: .medium))
                .foregroundStyle(conditionColor)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(
            Capsule()
                .fill(conditionColor.opacity(0.1))
        )
    }
    
    private var conditionColor: Color {
        switch condition {
        case .excellent: return .green
        case .good: return .teal
        case .fair: return .yellow
        case .poor: return .orange
        case .avoid: return .red
        }
    }
}

// MARK: - Mini Forecast Card

struct MiniForecastCard: View {
    let forecast: DayForecast
    let temperatureUnit: TemperatureUnit
    
    var body: some View {
        VStack(spacing: 6) {
            Text(dayName)
                .font(.system(.caption2, design: .rounded))
                .foregroundStyle(.secondary)
            
            Image(systemName: forecast.condition.icon)
                .font(.body)
                .symbolRenderingMode(.multicolor)
            
            Text("\(Int(temperatureUnit.convert(forecast.highTemp)))°")
                .font(.system(.caption, design: .rounded, weight: .medium))
            
            Text("\(Int(temperatureUnit.convert(forecast.lowTemp)))°")
                .font(.system(.caption2, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }
    
    private var dayName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: forecast.date)
    }
}

#Preview {
    VStack {
        WeatherCardView(
            weather: WeatherData(
                location: "Madison, WI",
                currentTemp: 12,
                feelsLike: 10,
                highTemp: 16,
                lowTemp: 2,
                humidity: 65,
                windSpeedKmh: 12,
                uvIndex: 4,
                condition: .partlyCloudy,
                precipitationMm: 0,
                precipitationChance: 20,
                sunrise: Date(),
                sunset: Date(),
                forecast: [],
                lastUpdated: Date()
            ),
            temperatureUnit: .celsius
        )
        .padding()
    }
    .background(Color(.systemGroupedBackground))
}
