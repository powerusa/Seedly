// NotificationService.swift
// Seedly

import Foundation
import UserNotifications

final class NotificationService {
    
    static let shared = NotificationService()
    
    private init() {}
    
    // MARK: - Permission
    func requestPermission() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .badge, .sound])
            return granted
        } catch {
            return false
        }
    }
    
    func checkPermissionStatus() async -> UNAuthorizationStatus {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        return settings.authorizationStatus
    }
    
    // MARK: - Frost Alert
    func scheduleFrostAlert(temperature: Double, date: Date) {
        let content = UNMutableNotificationContent()
        content.title = String(localized: "notification_frost_title")
        content.body = String(localized: "notification_frost_body \(Int(temperature))")
        content.sound = .default
        content.categoryIdentifier = "FROST_ALERT"
        content.interruptionLevel = .timeSensitive
        
        let triggerDate = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: date
        )
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "frost_\(date.timeIntervalSince1970)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    // MARK: - Heat Alert
    func scheduleHeatAlert(temperature: Double, date: Date) {
        let content = UNMutableNotificationContent()
        content.title = String(localized: "notification_heat_title")
        content.body = String(localized: "notification_heat_body \(Int(temperature))")
        content.sound = .default
        content.categoryIdentifier = "HEAT_ALERT"
        content.interruptionLevel = .timeSensitive
        
        let triggerDate = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: date
        )
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "heat_\(date.timeIntervalSince1970)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    // MARK: - Watering Reminder
    func scheduleWateringReminder(plantName: String, date: Date) {
        let content = UNMutableNotificationContent()
        content.title = String(localized: "notification_water_title")
        content.body = String(localized: "notification_water_body \(plantName)")
        content.sound = .default
        content.categoryIdentifier = "WATERING_REMINDER"
        
        let triggerDate = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: date
        )
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "water_\(plantName)_\(date.timeIntervalSince1970)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    // MARK: - Planting Reminder
    func schedulePlantingReminder(plantName: String, date: Date) {
        let content = UNMutableNotificationContent()
        content.title = String(localized: "notification_planting_title")
        content.body = String(localized: "notification_planting_body \(plantName)")
        content.sound = .default
        content.categoryIdentifier = "PLANTING_REMINDER"
        
        let triggerDate = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: date
        )
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "plant_\(plantName)_\(date.timeIntervalSince1970)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    // MARK: - Harvest Reminder
    func scheduleHarvestReminder(plantName: String, date: Date) {
        let content = UNMutableNotificationContent()
        content.title = String(localized: "notification_harvest_title")
        content.body = String(localized: "notification_harvest_body \(plantName)")
        content.sound = .default
        content.categoryIdentifier = "HARVEST_REMINDER"
        
        let triggerDate = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: date
        )
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "harvest_\(plantName)_\(date.timeIntervalSince1970)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    // MARK: - Cancel
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func cancelNotification(identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: [identifier]
        )
    }
    
    // MARK: - Categories
    func registerCategories() {
        let frostCategory = UNNotificationCategory(
            identifier: "FROST_ALERT",
            actions: [
                UNNotificationAction(identifier: "VIEW_TIPS", title: String(localized: "action_view_tips")),
            ],
            intentIdentifiers: []
        )
        
        let waterCategory = UNNotificationCategory(
            identifier: "WATERING_REMINDER",
            actions: [
                UNNotificationAction(identifier: "MARK_DONE", title: String(localized: "action_mark_done")),
                UNNotificationAction(identifier: "SNOOZE", title: String(localized: "action_snooze")),
            ],
            intentIdentifiers: []
        )
        
        UNUserNotificationCenter.current().setNotificationCategories([
            frostCategory,
            waterCategory
        ])
    }
}
