//
//  HomeworkListView.swift
//  Homeworky
//
//  Created by Leo Bähre on 2/18/25.
//


import SwiftUI

struct HomeworkListView: View {
    @ObservedObject var viewModel: HomeworkViewModel
    @Binding var selectedDate: Date
    @State private var isAddingHomework = false
    @State private var selectedHomework: Homework? // State variable to track the selected homework

    var filteredHomework: [Homework] {
        let calendar = Calendar.current
        let startOfSelectedDate = calendar.startOfDay(for: selectedDate)
        return viewModel.getHomework()[startOfSelectedDate] ?? []
    }

    var body: some View {
        VStack {
            if filteredHomework.isEmpty {
                List {
                    Text("No homework for this date.")
                        .foregroundColor(.gray)
                        .padding(.horizontal, 20)
                }
            } else {
                List {
                    ForEach(filteredHomework) { homework in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(homework.subject.name)
                                    .font(.subheadline)
                                    .foregroundColor(homework.subject.color)
                                Text(homework.title)
                                    .font(.body)
                            }
                            Spacer()
                            Image(systemName: homework.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(homework.isCompleted ? .green : .gray)
                                .onTapGesture {
                                    viewModel.toggleCompletion(for: homework)
                                }
                        }
                        .onTapGesture {
                            selectedHomework = homework // Store the selected homework
                        }
                    }
                    .onDelete { indexSet in
                        viewModel.deleteHomework(at: indexSet)
                    }
                }
            }
        }
        .sheet(item: $selectedHomework) { homework in
            EditHomeworkView(homework: homework, viewModel: viewModel)
        }
        .sheet(isPresented: $isAddingHomework) {
            AddHomeworkView(viewModel: viewModel, selectedDate: selectedDate)
        }
    }
}


// MARK: - Preview
struct PreviewWrapper: View {
    @StateObject private var viewModel = HomeworkViewModel()
    @State private var selectedDate = Date()
    
    init() {
        // Add some mock homework data
        viewModel.addHomework(subject: Config.subjects[0], title: "Finish exercises 1-5", dueDate: Date(), isCompleted: false)
        viewModel.addHomework(subject: Config.subjects[1], title: "Read chapter 4", dueDate: Date(), isCompleted: true)
    }
    
    var body: some View {
        HomeworkListView(viewModel: viewModel, selectedDate: $selectedDate)
    }
}

#Preview {
    PreviewWrapper()
}
