// GardenTask.swift
// Seedly

import Foundation
import SwiftData

@Model
final class GardenTask {
    var id: UUID
    var title: String
    var taskDescription: String
    var taskType: String
    var dueDate: Date
    var isCompleted: Bool
    var completedDate: Date?
    var isRecurring: Bool
    var recurringInterval: Int? // days between recurrence
    var relatedPlantId: String?
    var priority: String
    var garden: Garden?
    
    init(
        title: String,
        taskDescription: String = "",
        taskType: String,
        dueDate: Date,
        isRecurring: Bool = false,
        recurringInterval: Int? = nil,
        relatedPlantId: String? = nil,
        priority: String = "medium"
    ) {
        self.id = UUID()
        self.title = title
        self.taskDescription = taskDescription
        self.taskType = taskType
        self.dueDate = dueDate
        self.isCompleted = false
        self.isRecurring = isRecurring
        self.recurringInterval = recurringInterval
        self.relatedPlantId = relatedPlantId
        self.priority = priority
    }
}

enum TaskType: String, CaseIterable, Codable {
    case watering
    case fertilizing
    case pruning
    case harvesting
    case seedStarting
    case transplanting
    case pestInspection
    case weeding
    case mulching
    case soilTesting
    
    var icon: String {
        switch self {
        case .watering: return "drop.fill"
        case .fertilizing: return "leaf.arrow.circlepath"
        case .pruning: return "scissors"
        case .harvesting: return "basket.fill"
        case .seedStarting: return "sparkle"
        case .transplanting: return "arrow.up.arrow.down"
        case .pestInspection: return "ladybug.fill"
        case .weeding: return "xmark.circle"
        case .mulching: return "square.stack.3d.up"
        case .soilTesting: return "flask"
        }
    }
    
    var color: String {
        switch self {
        case .watering: return "blue"
        case .fertilizing: return "green"
        case .pruning: return "orange"
        case .harvesting: return "red"
        case .seedStarting: return "purple"
        case .transplanting: return "teal"
        case .pestInspection: return "yellow"
        case .weeding: return "brown"
        case .mulching: return "gray"
        case .soilTesting: return "indigo"
        }
    }
}

enum TaskPriority: String, CaseIterable, Codable {
    case low
    case medium
    case high
    case urgent
}
