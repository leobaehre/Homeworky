import SwiftUI

struct HomeworkListView: View {
    @ObservedObject var viewModel: HomeworkViewModel
    @Binding var selectedDate: Date
    
    var filteredHomework: [Homework] {
        let calendar = Calendar.current
        let startOfSelectedDate = calendar.startOfDay(for: selectedDate)
        return viewModel.getHomework()[startOfSelectedDate] ?? []
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Homework for \(formattedDate(selectedDate))")
                .font(.headline)
                .padding(.bottom, 5)
            
            if filteredHomework.isEmpty {
                Text("No homework for this date.")
                    .foregroundColor(.gray)
            } else {
                List {
                    ForEach(filteredHomework) { homework in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(homework.subject.name)
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
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
                    }
                    .onDelete { indexSet in
                        viewModel.deleteHomework(at: indexSet)
                    }
                }
            }
        }
        .padding()
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    HomeworkListView(viewModel: HomeworkViewModel(), selectedDate: .constant(Date()))
}
