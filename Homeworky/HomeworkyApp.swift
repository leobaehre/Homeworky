//
//  HomeworkyApp.swift
//  Homeworky
//
//  Created by Leo Bähre on 2/15/25.
//

import SwiftUI
import UserNotifications

@main
struct HomeworkyApp: App {
    
    init() {
        // Notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }
        NotificationManager.shared.requestNotificationPermission()
    }
    
    var body: some Scene {
        
        WindowGroup {
            ContentView()
        }
    }

}

class NotificationManager {
    static let shared = NotificationManager()

    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            DispatchQueue.main.async {
                if settings.authorizationStatus == .notDetermined {
                    center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                        if let error = error {
                            print("Notification permission error: \(error.localizedDescription)")
                        } else {
                            print(granted ? "Notifications allowed" : "Notifications denied")
                        }
                    }
                }
            }
        }
    }
}
