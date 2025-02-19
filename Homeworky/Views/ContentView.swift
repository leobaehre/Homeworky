//
//  ContentView.swift
//  Homeworky
//
//  Created by Leo Bähre on 2/15/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = HomeworkViewModel()
        @State private var showingAddHomework = false
        
        var body: some View {
            NavigationStack {
                List {
                    ForEach(viewModel.homeworkList) { homework in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(homework.title)
                                    .font(.headline)
                                Text(homework.subject)
                                    .font(.subheadline)
                                Text("Due: \(homework.dueDate, formatter: dateFormatter)")
                                    .font(.caption)
                            }
                            Spacer()
                            Button(action: {
                                viewModel.toggleCompletion(for: homework)
                            }) {
                                Image(systemName: homework.isCompleted ? "checkmark.circle.fill" : "circle")
                            }
                        }
                    }
                    .onDelete(perform: viewModel.deleteHomework)
                }
                .navigationTitle("Homework Tracker")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showingAddHomework = true
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                }
                .sheet(isPresented: $showingAddHomework) {
                    AddHomeworkView(viewModel: viewModel)
                }
            }
        }
}

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
}()

#Preview {
    ContentView()
}
