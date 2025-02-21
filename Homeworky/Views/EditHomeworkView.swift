//
//  AddHomeworkView.swift
//  Homeworky
//
//  Created by Leo Bähre on 2/15/25.
//

import SwiftUI

struct EditHomeworkView: View {
    var homework: Homework
    
    @ObservedObject var viewModel: HomeworkViewModel
    @Environment(\.dismiss) var dismiss
    
    let subjects: [Subject] = Config.subjects

    @State private var selectedSubject: String
    @State private var title: String
    @State private var dueDate: Date
    @State private var isCompleted: Bool

    init(homework: Homework, viewModel: HomeworkViewModel) {
        self.homework = homework
        self.viewModel = viewModel
        _selectedSubject = State(initialValue: homework.subject.name)
        _title = State(initialValue: homework.title)
        _dueDate = State(initialValue: homework.dueDate)
        _isCompleted = State(initialValue: homework.isCompleted)
    }

    var body: some View {
        NavigationStack {
            Form {
                Picker("Subject", selection: $selectedSubject) {
                    ForEach(subjects, id: \.name) { subject in
                        Text(subject.name).foregroundColor(subject.color)
                    }
                }
                TextField("Title", text: $title)
                DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                Toggle("Completed", isOn: $isCompleted)
            }
            .navigationTitle("Edit Homework")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if let subject = subjects.first(where: { $0.name == selectedSubject }) {
                            let updatedHomework = Homework(
                                id: homework.id,
                                subject: subject,
                                title: title,
                                dueDate: dueDate,
                                isCompleted: isCompleted
                            )
                            viewModel.updateHomework(updatedHomework)
                            dismiss()
                        }
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}
