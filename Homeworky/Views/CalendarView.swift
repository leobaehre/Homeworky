//
//  CalendarView.swift
//  Homeworky
//
//  Created by Leo Bähre on 2/15/25.
//

import SwiftUI

struct CalendarView: View {
    
    @ObservedObject var viewModel: HomeworkViewModel
    
    @Binding var selectedDate: Date // Bind selected date to an external source
    @State private var selectedIndex = 30 // Index of selected date
    @State private var days: [Date] = []
    @State private var isScrolling = false
    
    private let calendar = Calendar.current
    private let bufferSize = 30 // Number of days in each direction
    
    init(selectedDate: Binding<Date>, viewModel: HomeworkViewModel) {
        self.viewModel = viewModel
        let today = Date()
        let calendar = Calendar.current
        
        let initialRange = (-bufferSize...bufferSize).compactMap {
            calendar.date(byAdding: .day, value: $0, to: today)
        }
        _days = State(initialValue: initialRange)
        _selectedDate = selectedDate
    }
    
    var body: some View {
            // Show month and year of selected date
        VStack {
            Text(days[selectedIndex], format: .dateTime.month().year())
                .font(.headline)
                .foregroundStyle(.gray)
                .padding(.top, 16)
            
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(Array(days.enumerated()), id: \.offset) { index, day in
                            GeometryReader { geometry in
                                ZStack {
                                    
                                    VStack(spacing: 4) {
                                        Text(day, format: .dateTime.weekday(.short))
                                            .font(.caption)
                                            .foregroundStyle(.gray)
                                        
                                        ZStack {
                                            Circle()
                                                .fill(selectedIndex == index ? .blue : .clear)
                                                .frame(width: 60, height: 60)
                                            
                                            Text(day, format: .dateTime.day())
                                                .font(.title2)
                                                .fontWeight(.bold)
                                                .padding()
                                                .foregroundStyle(selectedIndex == index ?  .white : (Calendar.current.isDate(day, inSameDayAs: Date()) ? .blue : .primary))
                                        }
                                        
                                        
                                    }
                                    .frame(width: 60, height: 80)
                                    .onTapGesture {
                                        withAnimation {
                                            selectedIndex = index
                                            proxy.scrollTo(index, anchor: .center)
                                        }
                                    }
                                    .onAppear {
                                        updateSelectedIndex(geometry: geometry, index: index)
                                    }
                                    .onChange(of: geometry.frame(in: .global).midX) {
                                        updateSelectedIndex(geometry: geometry, index: index)
                                    }
                                           
                                    // Show a dot if there is homework for the day below the day number
                                    if viewModel.hasHomework(for: day) {
                                        Circle()
                                            .fill(selectedIndex == index ? .white : .blue)
                                            .frame(width: 8, height: 8)
                                            .offset(y: 30)
                                    }
                                }
                            }
                            .frame(width: 60, height: 80)
                            .id(index)
                        }
                    }
                }
                .onScrollPhaseChange { oldPhase, newPhase in
                    if newPhase == .interacting {
                        isScrolling = true
                    } else if newPhase == .idle && (oldPhase == .decelerating || oldPhase == .interacting) {
                        isScrolling = false
                        withAnimation {
                            proxy.scrollTo(selectedIndex, anchor: .center)
                        }
                    }
                }
                .onAppear {
                    proxy.scrollTo(selectedIndex, anchor: .center)
                }
                .onChange(of: selectedIndex) { _, index in
                    // haptic feedback
                    if (isScrolling) {
                        let generator = UISelectionFeedbackGenerator()
                        generator.selectionChanged()
                    }
                }
                .onChange(of: selectedDate) { _, newDate in
                    if let index = days.firstIndex(where: { calendar.isDate($0, inSameDayAs: newDate) }) {
                        if (!isScrolling) {
                            selectedIndex = index
                            withAnimation {
                                proxy.scrollTo(index, anchor: .center)
                            }
                        }
                    }
                }
            }
        }
    }
        
    private func updateSelectedIndex(geometry: GeometryProxy, index: Int) {
        let screenCenter = UIScreen.main.bounds.width / 2
        let itemCenter = geometry.frame(in: .global).midX
        let distance = abs(itemCenter - screenCenter)

        // Adjust the threshold for snapping (lower value for tighter snapping)
        if distance < 5 { // Adjust the threshold as needed
            DispatchQueue.main.async {
                selectedIndex = index
                selectedDate = days[selectedIndex]
            }
        }
    }
}
