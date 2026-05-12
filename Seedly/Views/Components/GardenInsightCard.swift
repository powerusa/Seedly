// GardenInsightCard.swift
// Seedly

import SwiftUI

struct GardenInsightCard: View {
    let insight: GardenInsight
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: 14) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(insightColor.opacity(0.15))
                    .frame(width: 42, height: 42)
                
                Image(systemName: insight.icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(insightColor)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 3) {
                Text(insight.title)
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    .foregroundStyle(.primary)
                
                Text(insight.subtitle)
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            if insight.actionable {
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: SeedlyTheme.cornerRadiusSmall)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
        )
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .animation(SeedlyTheme.springAnimation, value: isPressed)
        .onTapGesture {
            guard insight.actionable else { return }
            isPressed = true
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                isPressed = false
            }
        }
    }
    
    private var insightColor: Color {
        switch insight.type {
        case .planting: return .green
        case .frost: return .blue
        case .rain: return .cyan
        case .heat: return .orange
        case .harvest: return .red
        case .watering: return .teal
        case .wind: return .gray
        case .general: return .purple
        }
    }
}

// MARK: - Compact Insight Badge

struct CompactInsightBadge: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption2)
            Text(text)
                .font(.system(.caption2, design: .rounded, weight: .medium))
        }
        .foregroundStyle(color)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(
            Capsule()
                .fill(color.opacity(0.1))
                .overlay(
                    Capsule()
                        .stroke(color.opacity(0.2), lineWidth: 0.5)
                )
        )
    }
}

// MARK: - Daily Summary Card

struct DailySummaryCard: View {
    let date: Date
    let taskCount: Int
    let plantingCondition: GardeningImpact
    let topAction: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(dateString)
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.secondary)
                    Text("Today in Your Garden")
                        .font(.system(.headline, design: .rounded, weight: .semibold))
                }
                
                Spacer()
                
                GardeningConditionBadge(condition: plantingCondition)
            }
            
            Divider()
            
            HStack(spacing: 16) {
                SummaryItem(icon: "checklist", value: "\(taskCount)", label: "Tasks")
                SummaryItem(icon: "leaf.fill", value: topAction, label: "Top Action")
            }
        }
        .padding(SeedlyTheme.paddingMedium)
        .background(
            RoundedRectangle(cornerRadius: SeedlyTheme.cornerRadius)
                .fill(Color(.systemBackground))
        )
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)
    }
    
    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct SummaryItem: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(SeedlyTheme.primaryGreen)
            
            VStack(alignment: .leading, spacing: 1) {
                Text(value)
                    .font(.system(.caption, design: .rounded, weight: .semibold))
                Text(label)
                    .font(.system(.caption2, design: .rounded))
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        GardenInsightCard(insight: GardenInsight(
            type: .frost,
            title: "Frost risk tonight",
            subtitle: "Protect sensitive plants. Low of -2°C expected.",
            icon: "thermometer.snowflake",
            priority: 1,
            actionable: true
        ))
        
        GardenInsightCard(insight: GardenInsight(
            type: .planting,
            title: "Perfect week to plant carrots",
            subtitle: "Soil temperature is ideal for germination.",
            icon: "leaf.fill",
            priority: 2,
            actionable: true
        ))
        
        CompactInsightBadge(icon: "snowflake", text: "Frost risk", color: .blue)
    }
    .padding()
}
