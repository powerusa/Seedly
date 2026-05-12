// MainTabView.swift
// Seedly

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var localization: LocalizationManager
    @State private var selectedTab: TabItem = .today
    
    var body: some View {
        TabView(selection: $selectedTab) {
            TodayView()
                .tabItem {
                    Label(localization.tabToday, systemImage: TabItem.today.icon)
                }
                .tag(TabItem.today)
            
            CalendarScreenView()
                .tabItem {
                    Label(localization.tabCalendar, systemImage: TabItem.calendar.icon)
                }
                .tag(TabItem.calendar)
            
            PlantsView()
                .tabItem {
                    Label(localization.tabPlants, systemImage: TabItem.plants.icon)
                }
                .tag(TabItem.plants)
            
            TasksView()
                .tabItem {
                    Label(localization.tabTasks, systemImage: TabItem.tasks.icon)
                }
                .tag(TabItem.tasks)
            
            MoreView()
                .tabItem {
                    Label(localization.tabMore, systemImage: TabItem.more.icon)
                }
                .tag(TabItem.more)
        }
        .tint(SeedlyTheme.primaryGreen)
        .task {
            await appState.refreshWeather()
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(AppState())
        .environmentObject(LocalizationManager.shared)
}
