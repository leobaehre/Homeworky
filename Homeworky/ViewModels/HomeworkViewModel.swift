//
//  HomeworkViewModel.swift
//  Homeworky
//
//  Created by Leo Bähre on 2/15/25.
//
import SwiftUI

class HomeworkViewModel: ObservableObject {
    @Published var homeworkList: [Homework] = []
    
    func addHomework(subject: String, title: String, dueDate: Date) {
        let newHomework = Homework(subject: subject, title: title, dueDate: dueDate, isCompleted: false)
        homeworkList.append(newHomework)
    }
    
    func toggleCompletion(for homework: Homework) {
        if let index = homeworkList.firstIndex(where: { $0.id == homework.id }) {
            homeworkList[index].isCompleted.toggle()
        }
    }
    
    func deleteHomework(at offsets: IndexSet) {
        homeworkList.remove(atOffsets: offsets)
    }
}
