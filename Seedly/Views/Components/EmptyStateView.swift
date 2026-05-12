// EmptyStateView.swift
// Seedly

import SwiftUI

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(SeedlyTheme.accentGreen.opacity(0.1))
                    .frame(width: 80, height: 80)
                
                Image(systemName: icon)
                    .font(.system(size: 32))
                    .foregroundStyle(SeedlyTheme.accentGreen.opacity(0.6))
            }
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.system(.title3, design: .rounded, weight: .semibold))
                
                Text(message)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            if let actionTitle = actionTitle, let action = action {
                Button(action: action) {
                    Text(actionTitle)
                        .font(.system(.subheadline, design: .rounded, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(
                            Capsule()
                                .fill(SeedlyTheme.primaryGreen)
                        )
                }
                .padding(.top, 8)
            }
            
            Spacer()
        }
    }
}

// MARK: - Loading State View

struct LoadingStateView: View {
    let message: String
    @State private var animate = false
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .stroke(SeedlyTheme.accentGreen.opacity(0.2), lineWidth: 3)
                    .frame(width: 44, height: 44)
                
                Circle()
                    .trim(from: 0, to: 0.3)
                    .stroke(SeedlyTheme.accentGreen, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                    .frame(width: 44, height: 44)
                    .rotationEffect(.degrees(animate ? 360 : 0))
                    .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: animate)
            }
            .onAppear { animate = true }
            
            Text(message)
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Error State View

struct ErrorStateView: View {
    let error: String
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 36))
                .foregroundStyle(.orange)
            
            Text("Something went wrong")
                .font(.system(.headline, design: .rounded))
            
            Text(error)
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            Button(action: retryAction) {
                Label("Try Again", systemImage: "arrow.clockwise")
                    .font(.system(.subheadline, design: .rounded, weight: .medium))
                    .foregroundStyle(SeedlyTheme.primaryGreen)
            }
            .padding(.top, 4)
        }
        .padding(32)
    }
}

#Preview {
    VStack {
        EmptyStateView(
            icon: "leaf",
            title: "No Plants Yet",
            message: "Add your first plant to get started with personalized gardening advice.",
            actionTitle: "Add Plant"
        ) {}
    }
}
