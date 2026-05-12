// OnboardingView.swift
// Seedly

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var currentPage = 0
    @State private var selectedLanguage = "en"
    @State private var gardeningExperience: GardeningExperience = .beginner
    @State private var animateLeaf = false
    
    private let totalPages = 6
    
    var body: some View {
        ZStack {
            // Background
            SeedlyTheme.homeGradient
                .ignoresSafeArea()
            
            VStack {
                // Page content
                TabView(selection: $currentPage) {
                    welcomePage.tag(0)
                    languagePage.tag(1)
                    locationPage.tag(2)
                    climatePage.tag(3)
                    experiencePage.tag(4)
                    notificationsPage.tag(5)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(SeedlyTheme.springAnimation, value: currentPage)
                
                // Bottom area
                bottomArea
            }
        }
    }
    
    // MARK: - Welcome Page
    private var welcomePage: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // Logo
            ZStack {
                Circle()
                    .fill(SeedlyTheme.accentGreen.opacity(0.2))
                    .frame(width: 120, height: 120)
                    .scaleEffect(animateLeaf ? 1.05 : 1.0)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: animateLeaf)
                
                Image(systemName: "leaf.fill")
                    .font(.system(size: 56))
                    .foregroundStyle(SeedlyTheme.accentGreen)
                    .rotationEffect(.degrees(animateLeaf ? 5 : -5))
                    .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: animateLeaf)
            }
            .onAppear { animateLeaf = true }
            
            VStack(spacing: 12) {
                Text("Welcome to Simple Seeds")
                    .font(.system(.largeTitle, design: .rounded, weight: .bold))
                    .foregroundStyle(.white)
                
                Text("Your personal gardening calendar")
                    .font(.system(.title3, design: .rounded))
                    .foregroundStyle(.white.opacity(0.7))
            }
            
            VStack(spacing: 16) {
                OnboardingFeature(icon: "location.fill", text: "Personalized for your location")
                OnboardingFeature(icon: "thermometer.snowflake", text: "Frost & weather intelligence")
                OnboardingFeature(icon: "calendar", text: "Accurate planting windows")
                OnboardingFeature(icon: "bell.fill", text: "Smart reminders")
                OnboardingFeature(icon: "leaf.fill", text: "Track, grow and harvest")
            }
            .padding(.top, 12)
            
            Spacer()
            Spacer()
        }
        .padding(.horizontal, SeedlyTheme.paddingLarge)
    }
    
    // MARK: - Language Page
    private var languagePage: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "globe")
                .font(.system(size: 48))
                .foregroundStyle(SeedlyTheme.accentGreen)
            
            Text("Choose Your Language")
                .font(.system(.title2, design: .rounded, weight: .bold))
                .foregroundStyle(.white)
            
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(PlantLocalization.supportedLanguages) { language in
                        Button(action: { selectedLanguage = language.code }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(language.nativeName)
                                        .font(.system(.body, design: .rounded, weight: .medium))
                                    Text(language.name)
                                        .font(.system(.caption, design: .rounded))
                                        .opacity(0.7)
                                }
                                
                                Spacer()
                                
                                if selectedLanguage == language.code {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(SeedlyTheme.accentGreen)
                                }
                            }
                            .foregroundStyle(.white)
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(selectedLanguage == language.code ?
                                          SeedlyTheme.accentGreen.opacity(0.2) :
                                          Color.white.opacity(0.05))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(selectedLanguage == language.code ?
                                                    SeedlyTheme.accentGreen.opacity(0.5) :
                                                    Color.clear, lineWidth: 1)
                                    )
                            )
                        }
                    }
                }
            }
            .frame(maxHeight: 400)
            
            Spacer()
        }
        .padding(.horizontal, SeedlyTheme.paddingLarge)
    }
    
    // MARK: - Location Page
    private var locationPage: some View {
        VStack(spacing: 32) {
            Spacer()
            
            Image(systemName: "location.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(SeedlyTheme.accentGreen)
            
            VStack(spacing: 12) {
                Text("Your Location")
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .foregroundStyle(.white)
                
                Text("Simple Seeds uses your location to provide accurate planting calendars and weather-based recommendations.")
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 12) {
                Button(action: {
                    // Request location permission
                }) {
                    HStack {
                        Image(systemName: "location.fill")
                        Text("Use My Location")
                    }
                    .font(.system(.body, design: .rounded, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(SeedlyTheme.accentGreen)
                    )
                }
                
                Button(action: {}) {
                    Text("Enter Location Manually")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(.white.opacity(0.7))
                }
            }
            
            HStack(spacing: 8) {
                Image(systemName: "lock.shield.fill")
                    .font(.caption)
                Text("Your location is stored locally on your device only.")
                    .font(.system(.caption, design: .rounded))
            }
            .foregroundStyle(.white.opacity(0.5))
            
            Spacer()
            Spacer()
        }
        .padding(.horizontal, SeedlyTheme.paddingLarge)
    }
    
    // MARK: - Climate Page
    private var climatePage: some View {
        VStack(spacing: 32) {
            Spacer()
            
            Image(systemName: "cloud.sun.fill")
                .font(.system(size: 64))
                .foregroundStyle(SeedlyTheme.accentGreen)
            
            VStack(spacing: 12) {
                Text("Your Climate")
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .foregroundStyle(.white)
                
                Text("Simple Seeds automatically detects your climate zone and adapts all planting schedules accordingly.")
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 16) {
                ClimateInfoCard(title: "USDA Zone", value: "5a", icon: "thermometer")
                ClimateInfoCard(title: "Climate", value: "Continental", icon: "cloud.sun")
                ClimateInfoCard(title: "Growing Season", value: "~24 weeks", icon: "calendar")
                ClimateInfoCard(title: "Last Frost", value: "Mid-April", icon: "snowflake")
            }
            
            Spacer()
            Spacer()
        }
        .padding(.horizontal, SeedlyTheme.paddingLarge)
    }
    
    // MARK: - Experience Page
    private var experiencePage: some View {
        VStack(spacing: 32) {
            Spacer()
            
            Image(systemName: "person.fill")
                .font(.system(size: 48))
                .foregroundStyle(SeedlyTheme.accentGreen)
            
            VStack(spacing: 12) {
                Text("Gardening Experience")
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .foregroundStyle(.white)
                
                Text("This helps us personalize recommendations for you.")
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 12) {
                ForEach(GardeningExperience.allCases, id: \.self) { experience in
                    Button(action: { gardeningExperience = experience }) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(experience.title)
                                    .font(.system(.body, design: .rounded, weight: .semibold))
                                Text(experience.description)
                                    .font(.system(.caption, design: .rounded))
                                    .opacity(0.7)
                            }
                            
                            Spacer()
                            
                            if gardeningExperience == experience {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(SeedlyTheme.accentGreen)
                            }
                        }
                        .foregroundStyle(.white)
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(gardeningExperience == experience ?
                                      SeedlyTheme.accentGreen.opacity(0.2) :
                                      Color.white.opacity(0.05))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(gardeningExperience == experience ?
                                                SeedlyTheme.accentGreen.opacity(0.5) :
                                                Color.clear, lineWidth: 1)
                                )
                        )
                    }
                }
            }
            
            Spacer()
            Spacer()
        }
        .padding(.horizontal, SeedlyTheme.paddingLarge)
    }
    
    // MARK: - Notifications Page
    private var notificationsPage: some View {
        VStack(spacing: 32) {
            Spacer()
            
            Image(systemName: "bell.badge.fill")
                .font(.system(size: 48))
                .foregroundStyle(SeedlyTheme.accentGreen)
            
            VStack(spacing: 12) {
                Text("Stay Informed")
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .foregroundStyle(.white)
                
                Text("Get notified about frost alerts, watering reminders, and planting windows.")
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 16) {
                NotificationOption(icon: "thermometer.snowflake", title: "Frost Alerts", description: "Protect plants from cold")
                NotificationOption(icon: "drop.fill", title: "Watering Reminders", description: "Never forget to water")
                NotificationOption(icon: "leaf.fill", title: "Planting Reminders", description: "Perfect timing for planting")
                NotificationOption(icon: "basket.fill", title: "Harvest Reminders", description: "Pick at peak ripeness")
            }
            
            Button(action: {
                Task {
                    _ = await NotificationService.shared.requestPermission()
                }
            }) {
                HStack {
                    Image(systemName: "bell.fill")
                    Text("Enable Notifications")
                }
                .font(.system(.body, design: .rounded, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(SeedlyTheme.accentGreen)
                )
            }
            
            Button("Maybe Later") {}
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(.white.opacity(0.6))
            
            Spacer()
        }
        .padding(.horizontal, SeedlyTheme.paddingLarge)
    }
    
    // MARK: - Bottom Area
    private var bottomArea: some View {
        VStack(spacing: 16) {
            // Page indicators
            HStack(spacing: 8) {
                ForEach(0..<totalPages, id: \.self) { index in
                    Circle()
                        .fill(index == currentPage ? SeedlyTheme.accentGreen : Color.white.opacity(0.3))
                        .frame(width: index == currentPage ? 10 : 6, height: index == currentPage ? 10 : 6)
                        .animation(SeedlyTheme.springAnimation, value: currentPage)
                }
            }
            
            // Continue button
            Button(action: {
                if currentPage < totalPages - 1 {
                    withAnimation(SeedlyTheme.springAnimation) {
                        currentPage += 1
                    }
                } else {
                    completeOnboarding()
                }
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }) {
                Text(currentPage == totalPages - 1 ? "Get Started" : "Continue")
                    .font(.system(.body, design: .rounded, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(SeedlyTheme.accentGreen)
                    )
            }
            .padding(.horizontal, SeedlyTheme.paddingLarge)
            
            // Skip button
            if currentPage < totalPages - 1 {
                Button("Skip") {
                    completeOnboarding()
                }
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(.white.opacity(0.5))
            }
        }
        .padding(.bottom, 32)
    }
    
    private func completeOnboarding() {
        withAnimation {
            hasCompletedOnboarding = true
        }
    }
}

// MARK: - Supporting Views

struct OnboardingFeature: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.body)
                .foregroundStyle(SeedlyTheme.accentGreen)
                .frame(width: 28)
            
            Text(text)
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.white.opacity(0.85))
            
            Spacer()
        }
    }
}

struct ClimateInfoCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(SeedlyTheme.accentGreen)
                .frame(width: 32)
            
            Text(title)
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(.white.opacity(0.7))
            
            Spacer()
            
            Text(value)
                .font(.system(.subheadline, design: .rounded, weight: .semibold))
                .foregroundStyle(.white)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.05))
        )
    }
}

struct NotificationOption: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(SeedlyTheme.accentGreen)
                .frame(width: 28)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(.subheadline, design: .rounded, weight: .medium))
                    .foregroundStyle(.white)
                Text(description)
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.white.opacity(0.6))
            }
            
            Spacer()
        }
    }
}

// MARK: - Gardening Experience

enum GardeningExperience: String, CaseIterable {
    case beginner
    case intermediate
    case experienced
    case expert
    
    var title: String {
        switch self {
        case .beginner: return "Beginner"
        case .intermediate: return "Intermediate"
        case .experienced: return "Experienced"
        case .expert: return "Expert"
        }
    }
    
    var description: String {
        switch self {
        case .beginner: return "New to gardening, want simple guidance"
        case .intermediate: return "Some experience, growing a few plants"
        case .experienced: return "Several seasons, comfortable with most plants"
        case .expert: return "Years of experience, advanced techniques"
        }
    }
}

#Preview {
    OnboardingView()
        .environmentObject(AppState())
}
