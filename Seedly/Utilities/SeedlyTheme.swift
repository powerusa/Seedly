// SeedlyTheme.swift
// Seedly

import SwiftUI

struct SeedlyTheme {
    
    // MARK: - Colors
    static let primaryGreen = Color(red: 0.16, green: 0.35, blue: 0.14)
    static let secondaryGreen = Color(red: 0.22, green: 0.45, blue: 0.18)
    static let accentGreen = Color(red: 0.35, green: 0.60, blue: 0.28)
    static let lightGreen = Color(red: 0.85, green: 0.93, blue: 0.82)
    static let darkBackground = Color(red: 0.08, green: 0.14, blue: 0.07)
    static let cardBackground = Color(red: 0.12, green: 0.22, blue: 0.10)
    static let cardBackgroundLight = Color(red: 0.95, green: 0.97, blue: 0.94)
    static let warmWhite = Color(red: 0.98, green: 0.97, blue: 0.95)
    static let frost = Color(red: 0.70, green: 0.85, blue: 0.95)
    static let heat = Color(red: 0.95, green: 0.60, blue: 0.30)
    static let rain = Color(red: 0.50, green: 0.75, blue: 0.90)
    static let harvest = Color(red: 0.85, green: 0.30, blue: 0.20)
    
    // MARK: - Gradients
    static let springGradient = LinearGradient(
        colors: [
            Color(red: 0.10, green: 0.28, blue: 0.08),
            Color(red: 0.18, green: 0.40, blue: 0.14)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let summerGradient = LinearGradient(
        colors: [
            Color(red: 0.14, green: 0.32, blue: 0.10),
            Color(red: 0.25, green: 0.50, blue: 0.18)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let autumnGradient = LinearGradient(
        colors: [
            Color(red: 0.30, green: 0.22, blue: 0.08),
            Color(red: 0.45, green: 0.32, blue: 0.12)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let winterGradient = LinearGradient(
        colors: [
            Color(red: 0.15, green: 0.20, blue: 0.30),
            Color(red: 0.22, green: 0.28, blue: 0.38)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let homeGradient = LinearGradient(
        colors: [
            Color(red: 0.08, green: 0.18, blue: 0.06),
            Color(red: 0.12, green: 0.26, blue: 0.10),
            Color(red: 0.16, green: 0.32, blue: 0.12)
        ],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let frostGradient = LinearGradient(
        colors: [
            Color(red: 0.55, green: 0.75, blue: 0.90),
            Color(red: 0.70, green: 0.85, blue: 0.95)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // MARK: - Card Styles
    static let glassBackground = Color.white.opacity(0.08)
    static let glassBorder = Color.white.opacity(0.15)
    static let shadowColor = Color.black.opacity(0.2)
    
    // MARK: - Typography
    static let titleFont = Font.system(.title, design: .rounded, weight: .bold)
    static let headlineFont = Font.system(.headline, design: .rounded, weight: .semibold)
    static let bodyFont = Font.system(.body, design: .rounded)
    static let captionFont = Font.system(.caption, design: .rounded)
    static let largeTitle = Font.system(.largeTitle, design: .rounded, weight: .bold)
    
    // MARK: - Spacing
    static let paddingSmall: CGFloat = 8
    static let paddingMedium: CGFloat = 16
    static let paddingLarge: CGFloat = 24
    static let cornerRadius: CGFloat = 16
    static let cornerRadiusSmall: CGFloat = 10
    static let cornerRadiusLarge: CGFloat = 24
    
    // MARK: - Animation
    static let springAnimation = Animation.spring(response: 0.4, dampingFraction: 0.8)
    static let smoothAnimation = Animation.easeInOut(duration: 0.3)
    
    // MARK: - Seasonal Gradient
    static func seasonalGradient(for season: Season) -> LinearGradient {
        switch season {
        case .spring: return springGradient
        case .summer: return summerGradient
        case .autumn: return autumnGradient
        case .winter: return winterGradient
        }
    }
}

// MARK: - View Modifiers

struct GlassCardModifier: ViewModifier {
    var cornerRadius: CGFloat = SeedlyTheme.cornerRadius
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(SeedlyTheme.glassBorder, lineWidth: 0.5)
                    )
            )
            .shadow(color: SeedlyTheme.shadowColor, radius: 8, x: 0, y: 4)
    }
}

struct PremiumCardModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: SeedlyTheme.cornerRadius)
                    .fill(colorScheme == .dark ? SeedlyTheme.cardBackground : SeedlyTheme.cardBackgroundLight)
            )
            .shadow(color: SeedlyTheme.shadowColor.opacity(0.1), radius: 6, x: 0, y: 3)
    }
}

struct InsightCardModifier: ViewModifier {
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .padding(SeedlyTheme.paddingMedium)
            .background(
                RoundedRectangle(cornerRadius: SeedlyTheme.cornerRadiusSmall)
                    .fill(color.opacity(0.15))
                    .overlay(
                        RoundedRectangle(cornerRadius: SeedlyTheme.cornerRadiusSmall)
                            .stroke(color.opacity(0.3), lineWidth: 0.5)
                    )
            )
    }
}

// MARK: - View Extensions

extension View {
    func glassCard(cornerRadius: CGFloat = SeedlyTheme.cornerRadius) -> some View {
        modifier(GlassCardModifier(cornerRadius: cornerRadius))
    }
    
    func premiumCard() -> some View {
        modifier(PremiumCardModifier())
    }
    
    func insightCard(color: Color) -> some View {
        modifier(InsightCardModifier(color: color))
    }
    
    func hapticFeedback(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .light) -> some View {
        self.onTapGesture {
            UIImpactFeedbackGenerator(style: style).impactOccurred()
        }
    }
}
