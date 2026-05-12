// FrostAlertView.swift
// Seedly

import SwiftUI

struct FrostAlertView: View {
    let weather: WeatherData?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: SeedlyTheme.paddingLarge) {
                    // Alert header
                    alertHeader
                    
                    // At-risk plants
                    atRiskSection
                    
                    // Protection tips button
                    protectionTipsButton
                }
                .padding(.bottom, 40)
            }
            .background(
                LinearGradient(
                    colors: [
                        Color(red: 0.12, green: 0.20, blue: 0.30),
                        Color(red: 0.08, green: 0.14, blue: 0.22)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.white)
                    }
                }
            }
        }
    }
    
    // MARK: - Alert Header
    private var alertHeader: some View {
        VStack(spacing: 16) {
            // Frost icon
            ZStack {
                Circle()
                    .fill(SeedlyTheme.frost.opacity(0.2))
                    .frame(width: 80, height: 80)
                
                Image(systemName: "snowflake")
                    .font(.system(size: 36))
                    .foregroundStyle(SeedlyTheme.frost)
            }
            .padding(.top, 40)
            
            VStack(spacing: 8) {
                Text("Frost risk tonight")
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .foregroundStyle(.white)
                
                Text("Low of \(Int(weather?.lowTemp ?? -1))°F expected")
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(.white.opacity(0.7))
                
                Text("Protect sensitive plants.")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(.white.opacity(0.6))
            }
        }
    }
    
    // MARK: - At Risk Section
    private var atRiskSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("At Risk")
                .font(.system(.headline, design: .rounded, weight: .semibold))
                .foregroundStyle(.white)
                .padding(.horizontal, SeedlyTheme.paddingLarge)
            
            VStack(spacing: 8) {
                FrostRiskPlantRow(name: "Tomatoes", advice: "Consider covering", icon: "leaf.fill", color: .red)
                FrostRiskPlantRow(name: "Peppers", advice: "Bring indoors", icon: "leaf.fill", color: .orange)
                FrostRiskPlantRow(name: "Basil", advice: "Consider covering", icon: "leaf.fill", color: .green)
                FrostRiskPlantRow(name: "Cucumbers", advice: "Delicate to cold", icon: "leaf.fill", color: .teal)
            }
            .padding(.horizontal, SeedlyTheme.paddingLarge)
        }
    }
    
    // MARK: - Protection Tips
    private var protectionTipsButton: some View {
        Button(action: {}) {
            HStack {
                Image(systemName: "shield.fill")
                Text("View Protection Tips")
                    .font(.system(.body, design: .rounded, weight: .semibold))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(SeedlyTheme.accentGreen)
            )
        }
        .padding(.horizontal, SeedlyTheme.paddingLarge)
    }
}

// MARK: - Frost Risk Plant Row

struct FrostRiskPlantRow: View {
    let name: String
    let advice: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 44, height: 44)
                Image(systemName: icon)
                    .foregroundStyle(color)
            }
            
            VStack(alignment: .leading, spacing: 3) {
                Text(name)
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    .foregroundStyle(.white)
                Text(advice)
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.white.opacity(0.6))
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.4))
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: SeedlyTheme.cornerRadiusSmall)
                .fill(Color.white.opacity(0.06))
        )
    }
}

#Preview {
    FrostAlertView(weather: nil)
}
