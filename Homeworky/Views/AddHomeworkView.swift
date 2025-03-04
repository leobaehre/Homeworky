//
//  AddHomeworkView.swift
//  Homeworky
//
//  Created by Leo Bähre on 2/15/25.
//

import SwiftUI

struct AddHomeworkView: View {
    @ObservedObject var viewModel: HomeworkViewModel
    @Environment(\.dismiss) var dismiss
    
    let subjects: [Subject] = Config.subjects

    @State private var selectedSubject = "Honors Pre-Calculus"
    @State private var title = ""
    @State private var dueDate: Date

    init(viewModel: HomeworkViewModel, selectedDate: Date) {
        self.viewModel = viewModel
        _dueDate = State(initialValue: selectedDate)
    }

    var body: some View {
        NavigationStack {
            Form {
                Picker("Subject", selection: $selectedSubject) {
                    ForEach(subjects, id: \ .name) { subject in
                        Text(subject.name).foregroundColor(subject.color)
                    }
                }
                TextField("Title", text: $title)
                DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
            }
            .navigationTitle("Add Homework")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        if let subject = subjects.first(where: { $0.name == selectedSubject }) {
                            viewModel.addHomework(subject: subject, title: title, dueDate: dueDate)
                            dismiss()
                        }
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}
