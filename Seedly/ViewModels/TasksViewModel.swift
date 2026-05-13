// TasksViewModel.swift
// Seedly

import SwiftUI
import SwiftData

@MainActor
final class TasksViewModel: ObservableObject {
    @Published var todayTasks: [GardenTaskItem] = []
    @Published var upcomingTasks: [GardenTaskItem] = []
    @Published var completedTasks: [GardenTaskItem] = []
    @Published var selectedFilter: TaskFilter = .today
    
    init() {
        loadMockTasks()
    }
    
    func loadMockTasks() {
        let today = Date()
        let calendar = Calendar.current
        
        todayTasks = [
            GardenTaskItem(taskType: .watering, dueDate: today, plantId: "tomato"),
            GardenTaskItem(taskType: .pestInspection, dueDate: today, plantId: nil),
            GardenTaskItem(taskType: .harvesting, dueDate: today, plantId: "lettuce"),
        ]
        
        upcomingTasks = [
            GardenTaskItem(taskType: .fertilizing, dueDate: calendar.date(byAdding: .day, value: 2, to: today)!, plantId: "pepper"),
            GardenTaskItem(taskType: .seedStarting, dueDate: calendar.date(byAdding: .day, value: 3, to: today)!, plantId: "basil"),
            GardenTaskItem(taskType: .transplanting, dueDate: calendar.date(byAdding: .day, value: 5, to: today)!, plantId: "cucumber"),
            GardenTaskItem(taskType: .pruning, dueDate: calendar.date(byAdding: .day, value: 7, to: today)!, plantId: "mint"),
        ]
        
        completedTasks = [
            GardenTaskItem(taskType: .seedStarting, dueDate: calendar.date(byAdding: .day, value: -1, to: today)!, plantId: "carrot", isCompleted: true),
        ]
    }
    
    func toggleTask(_ task: GardenTaskItem) {
        if let index = todayTasks.firstIndex(where: { $0.id == task.id }) {
            todayTasks[index].isCompleted.toggle()
            if todayTasks[index].isCompleted {
                let completed = todayTasks.remove(at: index)
                completedTasks.insert(completed, at: 0)
            }
        } else if let index = upcomingTasks.firstIndex(where: { $0.id == task.id }) {
            upcomingTasks[index].isCompleted.toggle()
            if upcomingTasks[index].isCompleted {
                let completed = upcomingTasks.remove(at: index)
                completedTasks.insert(completed, at: 0)
            }
        } else if let index = completedTasks.firstIndex(where: { $0.id == task.id }) {
            completedTasks[index].isCompleted.toggle()
            let uncompleted = completedTasks.remove(at: index)
            todayTasks.append(uncompleted)
        }
    }
    
    var filteredTasks: [GardenTaskItem] {
        switch selectedFilter {
        case .today: return todayTasks
        case .upcoming: return upcomingTasks
        case .completed: return completedTasks
        }
    }
}

struct GardenTaskItem: Identifiable {
    let id = UUID()
    /// Custom user-entered title. When empty, a localized title is built from `taskType` + plant name.
    let customTitle: String
    let taskType: TaskType
    let dueDate: Date
    /// Plant ID from PlantDatabase (e.g. "tomato") — looked up & localized at display time.
    let plantId: String?
    var isCompleted: Bool
    
    init(
        customTitle: String = "",
        taskType: TaskType,
        dueDate: Date,
        plantId: String? = nil,
        isCompleted: Bool = false
    ) {
        self.customTitle = customTitle
        self.taskType = taskType
        self.dueDate = dueDate
        self.plantId = plantId
        self.isCompleted = isCompleted
    }
    
    /// Localized display name of the associated plant (or nil if none).
    @MainActor
    func plantDisplayName(language: String) -> String? {
        guard let plantId,
              let plant = PlantDatabase.shared.plant(byId: plantId) else { return nil }
        return plant.localizedName(for: language)
    }
    
    /// Localized task title — uses `customTitle` if provided, otherwise builds "<verb> <plant>".
    @MainActor
    func localizedTitle(using localization: LocalizationManager) -> String {
        if !customTitle.isEmpty { return customTitle }
        let verb = localization.taskVerb(taskType)
        if let plantName = plantDisplayName(language: localization.currentLanguage) {
            return "\(verb) \(plantName)"
        }
        return verb
    }
    
    @MainActor
    var dueDateString: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        let lang = LocalizationManager.shared.currentLanguage
        formatter.locale = Locale(identifier: lang)
        return formatter.localizedString(for: dueDate, relativeTo: Date())
    }
}

enum TaskFilter: String, CaseIterable {
    case today = "Today"
    case upcoming = "Upcoming"
    case completed = "Completed"
}
