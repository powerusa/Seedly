// TasksViewModel.swift
// Seedly

import SwiftUI
import SwiftData

@MainActor
final class TasksViewModel: ObservableObject {
    @Published private var tasks: [GardenTaskItem] = []
    @Published var selectedFilter: TaskFilter = .today
    private let defaults: UserDefaults
    private let storageKey = "garden.tasks.v1"

    var todayTasks: [GardenTaskItem] {
        tasks.filter { !$0.isCompleted && $0.dueDate < (Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: Date())) ?? Date()) }
            .sorted { $0.dueDate < $1.dueDate }
    }
    var upcomingTasks: [GardenTaskItem] {
        tasks.filter { task in
            !task.isCompleted && !todayTasks.contains(where: { $0.id == task.id })
        }.sorted { $0.dueDate < $1.dueDate }
    }
    var completedTasks: [GardenTaskItem] {
        tasks.filter(\.isCompleted).sorted { $0.dueDate > $1.dueDate }
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        if let data = defaults.data(forKey: storageKey),
           let saved = try? JSONDecoder().decode([GardenTaskItem].self, from: data) {
            tasks = saved
        }
    }

    func addTask(title: String, type: TaskType, dueDate: Date, recurringInterval: Int? = nil) {
        let title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !title.isEmpty else { return }
        tasks.append(GardenTaskItem(customTitle: title, taskType: type, dueDate: dueDate,
                                    recurringInterval: recurringInterval))
        save()
    }

    func toggleTask(_ task: GardenTaskItem) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        tasks[index].isCompleted.toggle()
        // A recurrence has a stable link to its source so undo/re-complete cannot duplicate it.
        if tasks[index].isCompleted, let interval = tasks[index].recurringInterval,
           interval > 0, !tasks.contains(where: { $0.sourceTaskId == task.id }),
           let nextDate = Calendar.current.date(byAdding: .day, value: interval, to: task.dueDate) {
            tasks.append(GardenTaskItem(customTitle: task.customTitle, taskType: task.taskType,
                                        dueDate: nextDate, plantId: task.plantId,
                                        recurringInterval: interval, sourceTaskId: task.id))
        }
        save()
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(tasks) else { return }
        defaults.set(data, forKey: storageKey)
    }

    var filteredTasks: [GardenTaskItem] {
        switch selectedFilter {
        case .today: return todayTasks
        case .upcoming: return upcomingTasks
        case .completed: return completedTasks
        }
    }
}

struct GardenTaskItem: Identifiable, Codable {
    let id: UUID
    let recurringInterval: Int?
    let sourceTaskId: UUID?
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
        isCompleted: Bool = false,
        recurringInterval: Int? = nil,
        sourceTaskId: UUID? = nil
    ) {
        self.id = UUID()
        self.recurringInterval = recurringInterval
        self.sourceTaskId = sourceTaskId
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
