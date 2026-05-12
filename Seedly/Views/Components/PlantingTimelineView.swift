// PlantingTimelineView.swift
// Seedly

import SwiftUI

struct PlantingTimelineView: View {
    let plant: Plant
    let zone: ClimateZone?
    
    @State private var animateTimeline = false
    
    private let months = ["J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Growing Timeline")
                .font(.system(.headline, design: .rounded, weight: .semibold))
            
            // Month labels
            HStack(spacing: 0) {
                ForEach(0..<12, id: \.self) { index in
                    Text(months[index])
                        .font(.system(.caption2, design: .rounded))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }
            
            // Indoor sowing bar
            if plant.indoorSeedWeeks != nil {
                TimelineBar(
                    label: "Indoor Sow",
                    startMonth: 2,
                    endMonth: 3,
                    color: .purple,
                    icon: "house.fill",
                    animate: animateTimeline
                )
            }
            
            // Outdoor planting bar
            TimelineBar(
                label: "Plant Outdoors",
                startMonth: 4,
                endMonth: 5,
                color: SeedlyTheme.accentGreen,
                icon: "leaf.fill",
                animate: animateTimeline
            )
            
            // Growing period
            TimelineBar(
                label: "Growing",
                startMonth: 5,
                endMonth: 8,
                color: .teal,
                icon: "arrow.up.circle.fill",
                animate: animateTimeline
            )
            
            // Harvest bar
            TimelineBar(
                label: "Harvest",
                startMonth: 7,
                endMonth: 9,
                color: .orange,
                icon: "basket.fill",
                animate: animateTimeline
            )
            
            // Current month indicator
            currentMonthIndicator
        }
        .padding(SeedlyTheme.paddingMedium)
        .background(
            RoundedRectangle(cornerRadius: SeedlyTheme.cornerRadius)
                .fill(Color(.systemBackground))
        )
        .onAppear {
            withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
                animateTimeline = true
            }
        }
    }
    
    private var currentMonthIndicator: some View {
        GeometryReader { geo in
            let currentMonth = Calendar.current.component(.month, from: Date())
            let monthWidth = geo.size.width / 12.0
            let xPosition = monthWidth * CGFloat(currentMonth - 1) + monthWidth / 2
            
            VStack(spacing: 2) {
                Image(systemName: "arrowtriangle.down.fill")
                    .font(.system(size: 8))
                    .foregroundStyle(SeedlyTheme.primaryGreen)
                Text("Now")
                    .font(.system(.caption2, design: .rounded, weight: .medium))
                    .foregroundStyle(SeedlyTheme.primaryGreen)
            }
            .position(x: xPosition, y: 12)
        }
        .frame(height: 28)
    }
}

struct TimelineBar: View {
    let label: String
    let startMonth: Int
    let endMonth: Int
    let color: Color
    let icon: String
    let animate: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.caption2)
                    .foregroundStyle(color)
                Text(label)
                    .font(.system(.caption, design: .rounded, weight: .medium))
                    .foregroundStyle(.secondary)
            }
            
            GeometryReader { geo in
                let totalWidth = geo.size.width
                let monthWidth = totalWidth / 12.0
                let barStart = monthWidth * CGFloat(startMonth - 1)
                let barWidth = monthWidth * CGFloat(endMonth - startMonth + 1)
                
                ZStack(alignment: .leading) {
                    // Track
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(.systemGray5))
                        .frame(height: 8)
                    
                    // Active bar
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color.opacity(0.7))
                        .frame(width: animate ? barWidth : 0, height: 8)
                        .offset(x: barStart)
                        .animation(.easeOut(duration: 0.6), value: animate)
                }
            }
            .frame(height: 8)
        }
    }
}

#Preview {
    PlantingTimelineView(plant: PlantDatabase.mockPlants[0], zone: nil)
        .padding()
}
