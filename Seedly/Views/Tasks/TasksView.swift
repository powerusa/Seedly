// TasksView.swift
// Seedly

import SwiftUI

struct TasksView: View {
    @StateObject private var viewModel = TasksViewModel()
    @EnvironmentObject var localization: LocalizationManager
    @State private var showAddTask = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                filterBar
                
                ScrollView {
                    LazyVStack(spacing: 12) {
                        if viewModel.filteredTasks.isEmpty {
                            emptyState
                        } else {
                            ForEach(viewModel.filteredTasks) { task in
                                TaskRow(task: task) {
                                    withAnimation(SeedlyTheme.springAnimation) {
                                        viewModel.toggleTask(task)
                                    }
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                }
                            }
                        }
                    }
                    .padding(.horizontal, SeedlyTheme.paddingLarge)
                    .padding(.top, SeedlyTheme.paddingMedium)
                    .padding(.bottom, 100)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(localization.tasks)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showAddTask = true }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(SeedlyTheme.primaryGreen)
                    }
                }
            }
            .sheet(isPresented: $showAddTask) {
                AddTaskSheet()
            }
        }
    }
    
    // MARK: - Filter Bar
    private var filterBar: some View {
        HStack(spacing: 8) {
            ForEach(TaskFilter.allCases, id: \.self) { filter in
                Button(action: {
                    withAnimation(SeedlyTheme.smoothAnimation) {
                        viewModel.selectedFilter = filter
                    }
                }) {
                    Text(localizedFilter(filter))
                        .font(.system(.subheadline, design: .rounded, weight: viewModel.selectedFilter == filter ? .semibold : .regular))
                        .foregroundStyle(viewModel.selectedFilter == filter ? .white : .primary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(viewModel.selectedFilter == filter ? SeedlyTheme.primaryGreen : Color(.systemGray6))
                        )
                }
            }
            Spacer()
        }
        .padding(.horizontal, SeedlyTheme.paddingLarge)
        .padding(.vertical, SeedlyTheme.paddingSmall)
    }
    
    // MARK: - Helpers
    private func localizedFilter(_ filter: TaskFilter) -> String {
        switch filter {
        case .today: return localization.today
        case .upcoming: return localization.upcoming
        case .completed: return localization.completed
        }
    }
    
    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.circle")
                .font(.system(size: 48))
                .foregroundStyle(SeedlyTheme.accentGreen.opacity(0.5))
            
            Text(localization.allCaughtUp)
                .font(.system(.title3, design: .rounded, weight: .semibold))
            
            Text(localization.noTasksInCategory)
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 60)
        .padding(.horizontal, 40)
    }
}

// MARK: - Task Row

struct TaskRow: View {
    let task: GardenTaskItem
    let onToggle: () -> Void
    @EnvironmentObject var localization: LocalizationManager
    
    var body: some View {
        HStack(spacing: 14) {
            // Checkbox
            Button(action: onToggle) {
                ZStack {
                    Circle()
                        .stroke(task.isCompleted ? SeedlyTheme.accentGreen : Color(.systemGray3), lineWidth: 2)
                        .frame(width: 26, height: 26)
                    
                    if task.isCompleted {
                        Circle()
                            .fill(SeedlyTheme.accentGreen)
                            .frame(width: 26, height: 26)
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.white)
                    }
                }
            }
            
            // Task icon
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(taskTypeColor(task.taskType).opacity(0.15))
                    .frame(width: 36, height: 36)
                Image(systemName: task.taskType.icon)
                    .font(.caption)
                    .foregroundStyle(taskTypeColor(task.taskType))
            }
            
            // Task info
            VStack(alignment: .leading, spacing: 3) {
                Text(task.localizedTitle(using: localization))
                    .font(.system(.subheadline, design: .rounded, weight: .medium))
                    .strikethrough(task.isCompleted)
                    .foregroundStyle(task.isCompleted ? .secondary : .primary)
                
                HStack(spacing: 4) {
                    if let plantName = task.plantDisplayName(language: localization.currentLanguage) {
                        Text(plantName)
                            .font(.system(.caption, design: .rounded))
                            .foregroundStyle(SeedlyTheme.primaryGreen)
                        
                        Text("•")
                            .foregroundStyle(.tertiary)
                    }
                    
                    Text(task.dueDateString)
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: SeedlyTheme.cornerRadiusSmall)
                .fill(Color(.systemBackground))
        )
        .shadow(color: .black.opacity(0.03), radius: 3, x: 0, y: 1)
    }
    
    private func taskTypeColor(_ type: TaskType) -> Color {
        switch type {
        case .watering: return .blue
        case .fertilizing: return .green
        case .pruning: return .orange
        case .harvesting: return .red
        case .seedStarting: return .purple
        case .transplanting: return .teal
        case .pestInspection: return .yellow
        case .weeding: return .brown
        case .mulching: return .gray
        case .soilTesting: return .indigo
        }
    }
}

// MARK: - Add Task Sheet

struct AddTaskSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var localization: LocalizationManager
    @State private var title = ""
    @State private var selectedType: TaskType = .watering
    @State private var dueDate = Date()
    @State private var isRecurring = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section(localization.taskDetails) {
                    TextField(localization.taskNameField, text: $title)
                    
                    Picker(localization.taskTypeField, selection: $selectedType) {
                        ForEach(TaskType.allCases, id: \.self) { type in
                            Label(localization.taskTypeName(type), systemImage: type.icon)
                                .tag(type)
                        }
                    }
                    
                    DatePicker(localization.dueDate, selection: $dueDate, displayedComponents: .date)
                    DatePicker(localization.dueTime, selection: $dueDate, displayedComponents: .hourAndMinute)
                }
                
                Section {
                    Toggle(localization.recurring, isOn: $isRecurring)
                }
            }
            .navigationTitle(localization.newTask)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(localization.cancel) { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(localization.add) { dismiss() }
                        .font(.system(.body, weight: .semibold))
                        .foregroundStyle(SeedlyTheme.primaryGreen)
                        .disabled(title.isEmpty)
                }
            }
        }
    }
}

#Preview {
    TasksView()
}
