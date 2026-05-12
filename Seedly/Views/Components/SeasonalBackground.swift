// SeasonalBackground.swift
// Seedly

import SwiftUI

struct SeasonalBackground: View {
    let season: Season
    @State private var animate = false
    
    var body: some View {
        ZStack {
            // Base gradient
            SeedlyTheme.seasonalGradient(for: season)
                .ignoresSafeArea()
            
            // Animated elements
            seasonalOverlay
        }
        .onAppear { animate = true }
    }
    
    @ViewBuilder
    private var seasonalOverlay: some View {
        switch season {
        case .spring:
            springOverlay
        case .summer:
            summerOverlay
        case .autumn:
            autumnOverlay
        case .winter:
            winterOverlay
        }
    }
    
    // MARK: - Spring
    private var springOverlay: some View {
        GeometryReader { geo in
            ForEach(0..<8, id: \.self) { i in
                Image(systemName: "leaf.fill")
                    .font(.system(size: CGFloat.random(in: 12...24)))
                    .foregroundStyle(.white.opacity(0.05))
                    .rotationEffect(.degrees(Double.random(in: 0...360)))
                    .offset(
                        x: CGFloat.random(in: 0...geo.size.width),
                        y: animate ?
                            CGFloat.random(in: 0...geo.size.height) :
                            CGFloat.random(in: 0...geo.size.height) + 15
                    )
                    .animation(
                        .easeInOut(duration: Double.random(in: 3...6))
                        .repeatForever(autoreverses: true)
                        .delay(Double(i) * 0.3),
                        value: animate
                    )
            }
        }
    }
    
    // MARK: - Summer
    private var summerOverlay: some View {
        GeometryReader { geo in
            // Sun glow
            Circle()
                .fill(
                    RadialGradient(
                        colors: [.yellow.opacity(0.08), .clear],
                        center: .center,
                        startRadius: 0,
                        endRadius: 150
                    )
                )
                .frame(width: 300, height: 300)
                .offset(x: geo.size.width * 0.6, y: -50)
                .scaleEffect(animate ? 1.1 : 0.95)
                .animation(.easeInOut(duration: 4).repeatForever(autoreverses: true), value: animate)
        }
    }
    
    // MARK: - Autumn
    private var autumnOverlay: some View {
        GeometryReader { geo in
            ForEach(0..<6, id: \.self) { i in
                Image(systemName: "leaf.arrow.triangle.circlepath")
                    .font(.system(size: CGFloat.random(in: 14...20)))
                    .foregroundStyle(.orange.opacity(0.06))
                    .rotationEffect(.degrees(animate ? Double.random(in: 0...360) : 0))
                    .offset(
                        x: CGFloat.random(in: 0...geo.size.width),
                        y: animate ?
                            geo.size.height + 50 :
                            CGFloat.random(in: -50...geo.size.height/2)
                    )
                    .animation(
                        .linear(duration: Double.random(in: 8...14))
                        .repeatForever(autoreverses: false)
                        .delay(Double(i) * 1.5),
                        value: animate
                    )
            }
        }
    }
    
    // MARK: - Winter
    private var winterOverlay: some View {
        GeometryReader { geo in
            ForEach(0..<12, id: \.self) { i in
                Circle()
                    .fill(.white.opacity(0.04))
                    .frame(width: CGFloat.random(in: 3...8))
                    .offset(
                        x: CGFloat.random(in: 0...geo.size.width),
                        y: animate ?
                            geo.size.height + 20 :
                            CGFloat.random(in: -20...0)
                    )
                    .animation(
                        .linear(duration: Double.random(in: 6...12))
                        .repeatForever(autoreverses: false)
                        .delay(Double(i) * 0.5),
                        value: animate
                    )
            }
        }
    }
}

// MARK: - Animated Plant Growth

struct PlantGrowthAnimation: View {
    @State private var growthProgress: CGFloat = 0
    let plant: Plant
    
    var body: some View {
        VStack(spacing: 0) {
            // Plant
            Image(systemName: "leaf.fill")
                .font(.system(size: 24))
                .foregroundStyle(SeedlyTheme.accentGreen)
                .scaleEffect(growthProgress)
                .opacity(growthProgress)
            
            // Stem
            Rectangle()
                .fill(SeedlyTheme.accentGreen.opacity(0.6))
                .frame(width: 2, height: 30 * growthProgress)
            
            // Soil line
            Ellipse()
                .fill(Color.brown.opacity(0.3))
                .frame(width: 40, height: 8)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.5)) {
                growthProgress = 1.0
            }
        }
    }
}

#Preview {
    SeasonalBackground(season: .spring)
}
