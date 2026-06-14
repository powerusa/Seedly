// CalendarScreenView.swift
// Seedly

import SwiftUI

struct CalendarScreenView: View {
    @StateObject private var viewModel = CalendarViewModel()
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var localization: LocalizationManager
    @State private var showMonthPicker = false
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: SeedlyTheme.paddingMedium) {
                    calendarHeader
                    weekdayHeader
                    calendarGrid
                    
                    Divider()
                        .padding(.horizontal)
                    
                    whatToPlantSection
                    comingUpSection
                }
                .padding(.bottom, 100)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(localization.calendar)
            .navigationBarTitleDisplayMode(.large)
            .task {
                appState.refreshLocation()
                viewModel.loadEvents(location: appState.currentLocation)
            }
            .onChange(of: appState.currentLocation) { _, location in
                viewModel.loadEvents(location: location)
            }
        }
    }
    
    // MARK: - Calendar Header
    private var calendarHeader: some View {
        HStack {
            Button(action: { viewModel.previousMonth() }) {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .foregroundStyle(SeedlyTheme.primaryGreen)
            }
            
            Spacer()
            
            Text(viewModel.monthTitle)
                .font(.system(.title3, design: .rounded, weight: .semibold))
            
            Spacer()
            
            Button(action: { viewModel.nextMonth() }) {
                Image(systemName: "chevron.right")
                    .font(.title3)
                    .foregroundStyle(SeedlyTheme.primaryGreen)
            }
        }
        .padding(.horizontal, SeedlyTheme.paddingLarge)
        .padding(.top, SeedlyTheme.paddingMedium)
    }
    
    // MARK: - Weekday Header
    private var weekdayHeader: some View {
        LazyVGrid(columns: columns, spacing: 4) {
            ForEach(viewModel.weekdaySymbols, id: \.self) { day in
                Text(day)
                    .font(.system(.caption, design: .rounded, weight: .medium))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, SeedlyTheme.paddingMedium)
    }
    
    // MARK: - Calendar Grid
    private var calendarGrid: some View {
        LazyVGrid(columns: columns, spacing: 4) {
            // Empty cells for offset
            ForEach(0..<viewModel.weekdayOffset, id: \.self) { _ in
                Color.clear
                    .frame(height: 44)
            }
            
            // Day cells
            ForEach(viewModel.daysInMonth, id: \.self) { date in
                CalendarDayCell(
                    date: date,
                    isSelected: Calendar.current.isDate(date, inSameDayAs: viewModel.selectedDate),
                    isToday: Calendar.current.isDateInToday(date),
                    hasEvents: viewModel.hasEvents(on: date),
                    events: viewModel.eventsForDate(date)
                )
                .onTapGesture {
                    withAnimation(SeedlyTheme.springAnimation) {
                        viewModel.selectDate(date)
                    }
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
            }
        }
        .padding(.horizontal, SeedlyTheme.paddingMedium)
    }
    
    // MARK: - Selected date subtitle
    private var selectedDateLabel: String {
        let cal = Calendar.current
        if cal.isDateInToday(viewModel.selectedDate) { return localization.today }
        let f = DateFormatter()
        f.locale = Locale(identifier: localization.currentLanguage)
        f.setLocalizedDateFormatFromTemplate("EEE, MMM d")
        return f.string(from: viewModel.selectedDate)
    }
    
    // MARK: - What to Plant Section (dynamic, anchored to selectedDate)
    private var whatToPlantSection: some View {
        let recs = viewModel.upcomingPlantings(within: 14, limit: 4)
        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(localization.whatToPlant)
                        .font(.system(.headline, design: .rounded, weight: .semibold))
                    Text(selectedDateLabel)
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Button(localization.viewAll) {}
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(SeedlyTheme.primaryGreen)
            }
            .padding(.horizontal, SeedlyTheme.paddingLarge)
            
            if recs.isEmpty {
                emptyRecommendation(message: localization.allCaughtUp)
            } else {
                VStack(spacing: 8) {
                    ForEach(recs) { rec in
                        plantRowLink(id: rec.plantId) {
                            CalendarPlantRow(
                                name: rec.plantName,
                                status: badgeText(for: rec),
                                statusColor: badgeColor(for: rec)
                            )
                        }
                    }
                }
                .padding(.horizontal, SeedlyTheme.paddingLarge)
            }
        }
    }
    
    // MARK: - Coming Up (events further in the future from selectedDate)
    private var comingUpSection: some View {
        let recs = viewModel.comingUpEvents(afterDays: 14, throughDays: 120, limit: 4)
        return VStack(alignment: .leading, spacing: 12) {
            Text(localization.comingUp)
                .font(.system(.headline, design: .rounded, weight: .semibold))
                .padding(.horizontal, SeedlyTheme.paddingLarge)
            
            if recs.isEmpty {
                emptyRecommendation(message: localization.noTasksInCategory)
            } else {
                VStack(spacing: 8) {
                    ForEach(recs) { rec in
                        plantRowLink(id: rec.plantId) {
                            ComingUpRow(
                                plantName: rec.plantName,
                                detail: detailText(for: rec),
                                icon: rec.eventType.icon
                            )
                        }
                    }
                }
                .padding(.horizontal, SeedlyTheme.paddingLarge)
            }
        }
    }
    
    @ViewBuilder
    private func emptyRecommendation(message: String) -> some View {
        Text(message)
            .font(.system(.subheadline, design: .rounded))
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, 8)
            .padding(.horizontal, SeedlyTheme.paddingLarge)
    }
    
    // MARK: - Row labels
    
    private func detailText(for rec: CalendarRecommendation) -> String {
        switch rec.eventType {
        case .harvest:                  return localization.harvestInDays(rec.daysFromSelected)
        case .seedStart:                return localization.startSeedsInDays(rec.daysFromSelected)
        case .planting, .transplant:    return localization.plantInDays(rec.daysFromSelected)
        }
    }
    
    private func badgeText(for rec: CalendarRecommendation) -> String {
        rec.daysFromSelected <= 0 ? localization.today : "\(rec.daysFromSelected)d"
    }
    
    private func badgeColor(for rec: CalendarRecommendation) -> Color {
        switch rec.daysFromSelected {
        case ..<0:  return .gray
        case 0...3: return .green
        case 4...7: return .teal
        default:    return .orange
        }
    }
    
    /// Wraps a row in a NavigationLink to PlantDetailView when the plant id
    /// resolves in the catalog. Falls back to the plain row otherwise.
    @ViewBuilder
    private func plantRowLink<Content: View>(id: String, @ViewBuilder content: () -> Content) -> some View {
        if let plant = PlantDatabase.shared.plant(byId: id) {
            NavigationLink(destination: PlantDetailView(plant: plant)) {
                content()
            }
            .buttonStyle(.plain)
        } else {
            content()
        }
    }
}

// MARK: - Calendar Day Cell

struct CalendarDayCell: View {
    let date: Date
    let isSelected: Bool
    let isToday: Bool
    let hasEvents: Bool
    let events: [PlantingEvent]
    
    var body: some View {
        VStack(spacing: 2) {
            Text("\(Calendar.current.component(.day, from: date))")
                .font(.system(.body, design: .rounded, weight: isToday ? .bold : .regular))
                .foregroundStyle(isSelected ? .white : isToday ? SeedlyTheme.primaryGreen : .primary)
                .frame(width: 36, height: 36)
                .background(
                    Circle()
                        .fill(isSelected ? SeedlyTheme.primaryGreen : Color.clear)
                )
                .overlay(
                    Circle()
                        .stroke(isToday && !isSelected ? SeedlyTheme.primaryGreen : Color.clear, lineWidth: 2)
                )
            
            // Event indicators
            HStack(spacing: 2) {
                if hasEvents {
                    ForEach(Array(events.prefix(3).enumerated()), id: \.offset) { _, event in
                        Circle()
                            .fill(event.color)
                            .frame(width: 4, height: 4)
                    }
                }
            }
            .frame(height: 6)
        }
        .frame(height: 44)
    }
}

// MARK: - Calendar Plant Row

struct CalendarPlantRow: View {
    let name: String
    let status: String
    let statusColor: Color
    
    var body: some View {
        HStack {
            Circle()
                .fill(SeedlyTheme.accentGreen.opacity(0.2))
                .frame(width: 36, height: 36)
                .overlay(
                    Image(systemName: "leaf.fill")
                        .font(.caption)
                        .foregroundStyle(SeedlyTheme.accentGreen)
                )
            
            Text(name)
                .font(.system(.subheadline, design: .rounded, weight: .medium))
            
            Spacer()
            
            Text(status)
                .font(.system(.caption, design: .rounded, weight: .medium))
                .foregroundStyle(statusColor)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(statusColor.opacity(0.1))
                )
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Coming Up Row

struct ComingUpRow: View {
    let plantName: String
    let detail: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(SeedlyTheme.accentGreen.opacity(0.15))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: icon)
                        .font(.subheadline)
                        .foregroundStyle(SeedlyTheme.accentGreen)
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(plantName)
                    .font(.system(.subheadline, design: .rounded, weight: .medium))
                Text(detail)
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    CalendarScreenView()
}
