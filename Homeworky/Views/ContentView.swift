//
//  ContentView.swift
//  Homeworky
//
//  Created by Leo Bähre on 2/15/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = HomeworkViewModel()
    @State private var selectedDate = Date()
    @State private var isAddingHomework = false


    var body: some View {
        NavigationStack {
            VStack {
                CalendarView(selectedDate: $selectedDate, viewModel: viewModel)
                
                HomeworkListView(viewModel: viewModel, selectedDate: $selectedDate)
            }
            .background(.gray.opacity(0.1))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        let today = Date()
                        selectedDate = today
                    }) {
                        Text("Today")
                            .font(.title2)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isAddingHomework = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $isAddingHomework) {
                AddHomeworkView(viewModel: viewModel, selectedDate: selectedDate)
            }
//            .gesture(DragGesture().onEnded { value in
//                if value.translation.width < -100 {
//                    selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate)!
//                } else if value.translation.width > 100 {
//                    selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate)!
//                }
//            })
        }
    }
}

#Preview {
    ContentView()
}
