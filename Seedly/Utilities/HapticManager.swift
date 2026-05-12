// HapticManager.swift
// Seedly

import UIKit

final class HapticManager {
    static let shared = HapticManager()
    
    private init() {}
    
    func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .light) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
    
    func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
    
    func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
    
    // MARK: - App-specific haptics
    
    func plantAdded() {
        notification(.success)
    }
    
    func taskCompleted() {
        impact(.medium)
    }
    
    func frostAlert() {
        notification(.warning)
    }
    
    func buttonTap() {
        impact(.light)
    }
    
    func tabSwitch() {
        selection()
    }
}
