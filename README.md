# 🌱 Simple Seeds – Global Planting Calendar

**Buy once. Garden forever.**

A premium native iOS gardening app that helps users worldwide know what to plant, when to plant, and how to care for their garden — all personalized to their exact location and climate.

## 📱 App Store

- **Title:** Seedly – Global Planting Calendar
- **Subtitle:** Plan. Plant. Grow.
- **Price:** $14.99–$24.99 (one-time purchase)
- **Rating:** 4.8 ★

## 🏗️ Architecture

| Layer | Technology |
|-------|-----------|
| UI | SwiftUI (iOS 18+) |
| Architecture | MVVM |
| Persistence | SwiftData |
| Concurrency | async/await |
| Purchases | StoreKit 2 |
| Weather | WeatherKit |
| Location | CoreLocation |
| Notifications | UserNotifications |
| Widgets | WidgetKit |

## 📂 Project Structure

```
Seedly/
├── App/
│   ├── SeedlyApp.swift          # App entry point
│   ├── AppState.swift           # Global app state
│   └── MainTabView.swift        # Tab navigation
├── Models/
│   ├── Plant.swift              # Plant data model
│   ├── Garden.swift             # Garden + SwiftData models
│   ├── GardenTask.swift         # Task management
│   ├── ClimateZone.swift        # Climate classification
│   └── WeatherData.swift        # Weather models
├── ViewModels/
│   ├── HomeViewModel.swift      # Today dashboard logic
│   ├── CalendarViewModel.swift  # Calendar calculations
│   ├── PlantsViewModel.swift    # Plant browsing/search
│   └── TasksViewModel.swift     # Task management
├── Views/
│   ├── Home/TodayView.swift     # Main dashboard
│   ├── Calendar/CalendarScreenView.swift
│   ├── Plants/PlantsView.swift  # Plant grid
│   ├── Plants/PlantDetailView.swift
│   ├── Tasks/TasksView.swift    # Task list
│   ├── Garden/MyGardenView.swift
│   ├── Alerts/FrostAlertView.swift
│   ├── Search/SearchView.swift
│   ├── Onboarding/OnboardingView.swift
│   ├── More/MoreView.swift
│   └── Components/             # Reusable UI components
├── Services/
│   ├── ClimateEngine.swift     # Köppen + USDA classification
│   ├── PlantingEngine.swift    # Smart planting calculations
│   ├── WeatherService.swift    # Weather data + insights
│   ├── LocationService.swift   # CoreLocation integration
│   ├── NotificationService.swift
│   ├── StoreKitManager.swift   # One-time purchase IAP
│   ├── PlantDatabase.swift     # Local plant database
│   └── PlantDataExpansion.swift # Additional plants
├── Utilities/
│   ├── SeedlyTheme.swift       # Design system
│   ├── PlantLocalization.swift # Multi-language plant names
│   ├── Extensions.swift        # Swift extensions
│   ├── HapticManager.swift     # Haptic feedback
│   └── Constants.swift         # App constants
├── Resources/
│   ├── Assets.xcassets/        # App icons, colors
│   └── Localizable.xcstrings   # Localization strings
├── PrivacyInfo.xcprivacy       # Privacy manifest
└── Info.plist
```

## 🌍 Supported Languages

English, Polish, Spanish, German, French, Italian, Portuguese, Dutch, Japanese, Korean, Chinese, Arabic, Hindi, Ukrainian, Russian

## 🌡️ Climate Engine

- **Köppen classification** – worldwide climate detection
- **USDA zones** – hardiness zone estimation
- **Frost dates** – automatic last/first frost calculation
- **Hemisphere awareness** – northern, southern, tropical
- **Growing season** – dynamic calculation by latitude

## 🌱 Plant Database

12+ plants included with architecture supporting thousands:
- Vegetables, Fruits, Herbs, Flowers, Berries, Trees, Tropical, Greenhouse
- Each plant: localized names, scientific name, planting windows, spacing, companions, difficulty, frost sensitivity, and more

## 🎨 Design Language

- Seasonal gradients (Spring/Summer/Autumn/Winter)
- Glassmorphism cards
- Premium rounded typography
- Smooth spring animations
- Subtle haptic feedback
- Dark-themed home dashboard inspired by Apple Weather
- Light-themed content screens

## 💰 Monetization

**STRICTLY one-time purchase. No subscriptions. No ads. No accounts.**

Optional future expansion packs:
- Greenhouse Pack
- Tropical Plants Pack
- Orchard Pack
- Professional Farming Pack

## 🔒 Privacy

- No tracking
- No analytics
- No accounts
- No data collection
- Location used on-device only
- Full offline functionality

## 🚀 Getting Started

1. Open `Seedly.xcodeproj` in Xcode 16+
2. Select iOS 18+ simulator or device
3. Build and run

> **Note:** For production WeatherKit integration, configure your Apple Developer account with WeatherKit capability. The app uses mock weather data for development.

## 📋 Requirements

- Xcode 16.0+
- iOS 18.0+
- Swift 6.0
- Apple Developer Account (for WeatherKit + StoreKit)

## 🧪 Testing

- All ViewModels support preview data
- Mock weather generation for development
- SwiftData in-memory containers for previews
- Widget previews included

---

*Made with 🌱 by Seedly*
