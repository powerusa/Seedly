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
            GardenTaskItem(
                title: "Water tomatoes",
                taskType: .watering,
                dueDate: today,
                plantName: "Tomatoes",
                isCompleted: false
            ),
            GardenTaskItem(
                title: "Check for pests",
                taskType: .pestInspection,
                dueDate: today,
                plantName: nil,
                isCompleted: false
            ),
            GardenTaskItem(
                title: "Harvest lettuce",
                taskType: .harvesting,
                dueDate: today,
                plantName: "Lettuce",
                isCompleted: false
            ),
        ]
        
        upcomingTasks = [
            GardenTaskItem(
                title: "Fertilize peppers",
                taskType: .fertilizing,
                dueDate: calendar.date(byAdding: .day, value: 2, to: today)!,
                plantName: "Peppers",
                isCompleted: false
            ),
            GardenTaskItem(
                title: "Start basil indoors",
                taskType: .seedStarting,
                dueDate: calendar.date(byAdding: .day, value: 3, to: today)!,
                plantName: "Basil",
                isCompleted: false
            ),
            GardenTaskItem(
                title: "Transplant cucumbers",
                taskType: .transplanting,
                dueDate: calendar.date(byAdding: .day, value: 5, to: today)!,
                plantName: "Cucumbers",
                isCompleted: false
            ),
            GardenTaskItem(
                title: "Prune mint",
                taskType: .pruning,
                dueDate: calendar.date(byAdding: .day, value: 7, to: today)!,
                plantName: "Mint",
                isCompleted: false
            ),
        ]
        
        completedTasks = [
            GardenTaskItem(
                title: "Plant carrots",
                taskType: .seedStarting,
                dueDate: calendar.date(byAdding: .day, value: -1, to: today)!,
                plantName: "Carrots",
                isCompleted: true
            ),
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
    let title: String
    let taskType: TaskType
    let dueDate: Date
    let plantName: String?
    var isCompleted: Bool
    
    var dueDateString: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: dueDate, relativeTo: Date())
    }
}

enum TaskFilter: String, CaseIterable {
    case today = "Today"
    case upcoming = "Upcoming"
    case completed = "Completed"
}
