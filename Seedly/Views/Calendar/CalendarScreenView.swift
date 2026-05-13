// CalendarScreenView.swift
// Seedly

import SwiftUI

struct CalendarScreenView: View {
    @StateObject private var viewModel = CalendarViewModel()
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
                viewModel.loadEvents()
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
    
    // MARK: - What to Plant Section
    private var whatToPlantSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(localization.whatToPlant)
                    .font(.system(.headline, design: .rounded, weight: .semibold))
                Spacer()
                Button(localization.viewAll) {}
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(SeedlyTheme.primaryGreen)
            }
            .padding(.horizontal, SeedlyTheme.paddingLarge)
            
            VStack(spacing: 8) {
                CalendarPlantRow(name: PlantLocalization.localizedName(for: "plant_lettuce", locale: localization.currentLanguage), status: localization.excellent, statusColor: .green)
                CalendarPlantRow(name: PlantLocalization.localizedName(for: "plant_carrot", locale: localization.currentLanguage), status: localization.excellent, statusColor: .green)
                CalendarPlantRow(name: PlantLocalization.localizedName(for: "plant_onion", locale: localization.currentLanguage), status: localization.good, statusColor: .teal)
                CalendarPlantRow(name: PlantLocalization.localizedName(for: "plant_spinach", locale: localization.currentLanguage), status: localization.good, statusColor: .teal)
            }
            .padding(.horizontal, SeedlyTheme.paddingLarge)
        }
    }
    
    // MARK: - Coming Up
    private var comingUpSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(localization.comingUp)
                .font(.system(.headline, design: .rounded, weight: .semibold))
                .padding(.horizontal, SeedlyTheme.paddingLarge)
            
            VStack(spacing: 8) {
                ComingUpRow(
                    plantName: PlantLocalization.localizedName(for: "plant_tomato", locale: localization.currentLanguage),
                    detail: localization.safePlantIn(days: 12),
                    icon: "leaf.fill"
                )
                ComingUpRow(
                    plantName: PlantLocalization.localizedName(for: "plant_pepper", locale: localization.currentLanguage),
                    detail: localization.safePlantIn(days: 14),
                    icon: "leaf.fill"
                )
            }
            .padding(.horizontal, SeedlyTheme.paddingLarge)
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
