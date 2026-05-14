// SeedlyWidgets.swift
// SeedlyWidgets

import WidgetKit
import SwiftUI

// MARK: - Today Widget

struct TodayGardenEntry: TimelineEntry {
    let date: Date
    let temperature: Int
    let condition: String
    let frostRisk: Bool
    let topInsight: String
    let plantToPlant: String
}

struct TodayGardenProvider: TimelineProvider {
    func placeholder(in context: Context) -> TodayGardenEntry {
        TodayGardenEntry(
            date: Date(),
            temperature: 15,
            condition: "Partly Cloudy",
            frostRisk: false,
            topInsight: "Perfect week to plant carrots",
            plantToPlant: "Lettuce"
        )
    }
    
    func getSnapshot(in context: Context, completion: @escaping (TodayGardenEntry) -> Void) {
        completion(placeholder(in: context))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<TodayGardenEntry>) -> Void) {
        let entry = TodayGardenEntry(
            date: Date(),
            temperature: 15,
            condition: "Partly Cloudy",
            frostRisk: false,
            topInsight: "Perfect week to plant carrots",
            plantToPlant: "Lettuce"
        )
        
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}

struct TodayGardenWidgetView: View {
    var entry: TodayGardenEntry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family {
        case .systemSmall:
            smallWidget
        case .systemMedium:
            mediumWidget
        default:
            smallWidget
        }
    }
    
    private var smallWidget: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "leaf.fill")
                    .foregroundStyle(.green)
                Text("Simple Seeds")
                    .font(.system(.caption2, design: .rounded, weight: .bold))
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text("\(entry.temperature)°")
                .font(.system(size: 32, weight: .thin, design: .rounded))
            
            Text(entry.topInsight)
                .font(.system(.caption, design: .rounded))
                .foregroundStyle(.secondary)
                .lineLimit(2)
            
            if entry.frostRisk {
                HStack(spacing: 3) {
                    Image(systemName: "snowflake")
                        .font(.caption2)
                    Text("Frost risk")
                        .font(.system(.caption2, design: .rounded))
                }
                .foregroundStyle(.blue)
            }
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
    
    private var mediumWidget: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "leaf.fill")
                        .foregroundStyle(.green)
                    Text("Today in Your Garden")
                        .font(.system(.caption, design: .rounded, weight: .semibold))
                }
                
                Text("\(entry.temperature)°")
                    .font(.system(size: 36, weight: .thin, design: .rounded))
                
                Text(entry.condition)
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                if entry.frostRisk {
                    HStack(spacing: 3) {
                        Image(systemName: "snowflake")
                            .font(.caption)
                        Text("Frost risk tonight")
                            .font(.system(.caption, design: .rounded))
                    }
                    .foregroundStyle(.blue)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 8) {
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Plant today:")
                        .font(.system(.caption2, design: .rounded))
                        .foregroundStyle(.secondary)
                    Text(entry.plantToPlant)
                        .font(.system(.subheadline, design: .rounded, weight: .medium))
                }
                
                Text(entry.topInsight)
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.green)
                    .multilineTextAlignment(.trailing)
                    .lineLimit(2)
            }
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

struct TodayGardenWidget: Widget {
    let kind: String = "TodayGardenWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TodayGardenProvider()) { entry in
            TodayGardenWidgetView(entry: entry)
        }
        .configurationDisplayName("Today in Your Garden")
        .description("See today's gardening insights at a glance.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// MARK: - Frost Alert Widget

struct FrostAlertEntry: TimelineEntry {
    let date: Date
    let hasFrostRisk: Bool
    let lowTemp: Int
    let daysUntilSafe: Int
}

struct FrostAlertProvider: TimelineProvider {
    func placeholder(in context: Context) -> FrostAlertEntry {
        FrostAlertEntry(date: Date(), hasFrostRisk: true, lowTemp: -2, daysUntilSafe: 6)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (FrostAlertEntry) -> Void) {
        completion(placeholder(in: context))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<FrostAlertEntry>) -> Void) {
        let entry = FrostAlertEntry(date: Date(), hasFrostRisk: true, lowTemp: -2, daysUntilSafe: 6)
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 2, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}

struct FrostAlertWidgetView: View {
    var entry: FrostAlertEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: "thermometer.snowflake")
                    .foregroundStyle(.blue)
                Text("Frost Alert")
                    .font(.system(.caption, design: .rounded, weight: .semibold))
            }
            
            Spacer()
            
            if entry.hasFrostRisk {
                Text("\(entry.lowTemp)°")
                    .font(.system(size: 28, weight: .medium, design: .rounded))
                    .foregroundStyle(.blue)
                
                Text("Tonight's low")
                    .font(.system(.caption2, design: .rounded))
                    .foregroundStyle(.secondary)
            } else {
                Image(systemName: "checkmark.shield.fill")
                    .font(.title2)
                    .foregroundStyle(.green)
                Text("No frost risk")
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

struct FrostAlertWidget: Widget {
    let kind: String = "FrostAlertWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: FrostAlertProvider()) { entry in
            FrostAlertWidgetView(entry: entry)
        }
        .configurationDisplayName("Frost Alert")
        .description("Get frost warnings at a glance.")
        .supportedFamilies([.systemSmall, .accessoryRectangular])
    }
}

// MARK: - Lock Screen Widget

struct LockScreenFrostView: View {
    var entry: FrostAlertEntry
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: entry.hasFrostRisk ? "snowflake" : "checkmark.shield")
                .font(.caption)
            
            VStack(alignment: .leading, spacing: 1) {
                Text(entry.hasFrostRisk ? "Frost risk" : "No frost risk")
                    .font(.system(.caption, design: .rounded, weight: .medium))
                if entry.hasFrostRisk {
                    Text("Low: \(entry.lowTemp)°")
                        .font(.system(.caption2, design: .rounded))
                }
            }
        }
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

// MARK: - Widget Bundle

// NOTE: When adding as a separate Widget Extension target in Xcode,
// uncomment the @main attribute below.
// @main
struct SeedlyWidgetBundle: WidgetBundle {
    var body: some Widget {
        TodayGardenWidget()
        FrostAlertWidget()
    }
}
