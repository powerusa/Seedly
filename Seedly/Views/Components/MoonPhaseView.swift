// MoonPhaseView.swift
// Seedly

import SwiftUI

struct MoonPhaseView: View {
    let date: Date
    
    private var moonPhase: MoonPhase {
        MoonPhaseCalculator.phase(for: date)
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: moonPhase.icon)
                .font(.title2)
                .foregroundStyle(.yellow.opacity(0.8))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(moonPhase.name)
                    .font(.system(.subheadline, design: .rounded, weight: .medium))
                Text(moonPhase.gardeningAdvice)
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .padding(SeedlyTheme.paddingMedium)
        .background(
            RoundedRectangle(cornerRadius: SeedlyTheme.cornerRadiusSmall)
                .fill(Color(.systemBackground))
        )
    }
}

enum MoonPhase: String {
    case newMoon
    case waxingCrescent
    case firstQuarter
    case waxingGibbous
    case fullMoon
    case waningGibbous
    case lastQuarter
    case waningCrescent
    
    var name: String {
        switch self {
        case .newMoon: return "New Moon"
        case .waxingCrescent: return "Waxing Crescent"
        case .firstQuarter: return "First Quarter"
        case .waxingGibbous: return "Waxing Gibbous"
        case .fullMoon: return "Full Moon"
        case .waningGibbous: return "Waning Gibbous"
        case .lastQuarter: return "Last Quarter"
        case .waningCrescent: return "Waning Crescent"
        }
    }
    
    var icon: String {
        switch self {
        case .newMoon: return "moon.fill"
        case .waxingCrescent: return "moon.stars.fill"
        case .firstQuarter: return "moon.zzz.fill"
        case .waxingGibbous: return "moon.haze.fill"
        case .fullMoon: return "moon.circle.fill"
        case .waningGibbous: return "moon.haze.fill"
        case .lastQuarter: return "moon.zzz.fill"
        case .waningCrescent: return "moon.stars.fill"
        }
    }
    
    var gardeningAdvice: String {
        switch self {
        case .newMoon: return "Good for planting leafy crops"
        case .waxingCrescent: return "Plant above-ground crops"
        case .firstQuarter: return "Best for fruiting plants"
        case .waxingGibbous: return "Good for transplanting"
        case .fullMoon: return "Best for root crops"
        case .waningGibbous: return "Good for pruning"
        case .lastQuarter: return "Rest period – no planting"
        case .waningCrescent: return "Prepare beds, compost"
        }
    }
}

struct MoonPhaseCalculator {
    static func phase(for date: Date) -> MoonPhase {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        guard let year = components.year,
              let month = components.month,
              let day = components.day else {
            return .newMoon
        }
        
        // Simplified moon phase calculation
        var adjustedYear = year
        var adjustedMonth = month
        
        if adjustedMonth < 3 {
            adjustedYear -= 1
            adjustedMonth += 12
        }
        
        let a = adjustedYear / 100
        let b = a / 4
        let c = 2 - a + b
        let e = Int(365.25 * Double(adjustedYear + 4716))
        let f = Int(30.6001 * Double(adjustedMonth + 1))
        let julianDay = Double(c + day + e + f) - 1524.5
        
        let daysSinceNew = julianDay - 2451549.5
        let newMoons = daysSinceNew / 29.53058867
        let fraction = newMoons - Double(Int(newMoons))
        let phase = fraction * 8.0
        
        switch Int(phase) {
        case 0: return .newMoon
        case 1: return .waxingCrescent
        case 2: return .firstQuarter
        case 3: return .waxingGibbous
        case 4: return .fullMoon
        case 5: return .waningGibbous
        case 6: return .lastQuarter
        case 7: return .waningCrescent
        default: return .newMoon
        }
    }
}

#Preview {
    MoonPhaseView(date: Date())
        .padding()
}
