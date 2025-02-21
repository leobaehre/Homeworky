//
//  HomeworkViewModel.swift
//  Homeworky
//
//  Created by Leo Bähre on 2/15/25.
//

import SwiftUI

class HomeworkViewModel: ObservableObject {
    @Published var homeworkList: [Homework] = [] {
        didSet {
            saveHomework()
        }
    }

    private let fileName = "homeworkList.json"

    init() {
        loadHomework()
    }

    func getHomework() -> [Date: [Homework]] {
        let calendar = Calendar.current
        return Dictionary(grouping: homeworkList, by: { calendar.startOfDay(for: $0.dueDate) })
    }
    
    func hasHomework(for date: Date) -> Bool {
        let calendar = Calendar.current
        let startOfDate = calendar.startOfDay(for: date)
        return getHomework()[startOfDate] != nil
    }

    func addHomework(subject: Subject, title: String, dueDate: Date, isCompleted: Bool = false) {
        let newHomework = Homework(subject: subject, title: title, dueDate: dueDate, isCompleted: isCompleted)
        homeworkList.append(newHomework)
        setHomeworkNotification()
    }
    
    func updateHomework(_ homework: Homework) {
        if let index = homeworkList.firstIndex(where: { $0.id == homework.id }) {
            homeworkList[index] = homework
            setHomeworkNotification()
        }
    }

    func toggleCompletion(for homework: Homework) {
        if let index = homeworkList.firstIndex(where: { $0.id == homework.id }) {
            homeworkList[index].isCompleted.toggle()
            setHomeworkNotification()
        }
    }

    func deleteHomework(at offsets: IndexSet) {
        homeworkList.remove(atOffsets: offsets)
        setHomeworkNotification()
    }
    
    // MARK: - Notification Methods
    func setHomeworkNotification() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests() // Remove old notifications

        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        let tomorrowStart = Calendar.current.startOfDay(for: tomorrow)
        
        let hasIncompleteHomework = homeworkList.contains { homework in
            Calendar.current.startOfDay(for: homework.dueDate) == tomorrowStart && !homework.isCompleted
        }

        guard hasIncompleteHomework else { return } // No need to send a notification

        let content = UNMutableNotificationContent()
        content.title = "Homework Reminder 📚"
        content.body = "You have unfinished homework due tomorrow. Don't forget to complete it!"
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = 18
        dateComponents.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: "homeworkReminder", content: content, trigger: trigger)

        center.add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully")
            }
        }
    }

    // MARK: - Persistence Methods

    private func saveHomework() {
        do {
            let data = try JSONEncoder().encode(homeworkList)
            let url = getFileURL()
            try data.write(to: url, options: .atomic)
        } catch {
            print("Failed to save homework: \(error.localizedDescription)")
        }
    }

    private func loadHomework() {
        let url = getFileURL()
        do {
            let data = try Data(contentsOf: url)
            homeworkList = try JSONDecoder().decode([Homework].self, from: data)
        } catch {
            print("No saved homework found or failed to load: \(error.localizedDescription)")
        }
    }

    private func getFileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent(fileName)
    }
}
