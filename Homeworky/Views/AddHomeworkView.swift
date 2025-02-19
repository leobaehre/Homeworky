//
//  AddHomeworkView.swift
//  Homeworky
//
//  Created by Leo Bähre on 2/15/25.
//

struct AddHomeworkView: View {
    @ObservedObject var viewModel: HomeworkViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var subject = ""
    @State private var title = ""
    @State private var dueDate = Date()
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Subject", text: $subject)
                TextField("Title", text: $title)
                DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
            }
            .navigationTitle("Add Homework")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.addHomework(subject: subject, title: title, dueDate: dueDate)
                        dismiss()
                    }
                }
            }
        }
    }
}
