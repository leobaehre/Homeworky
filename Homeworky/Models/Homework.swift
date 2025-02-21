//
//  Homework.swift
//  Homeworky
//
//  Created by Leo Bähre on 2/15/25.
//

import Foundation

struct Homework: Identifiable, Codable {
    var id = UUID()
    var subject: Subject
    var title: String
    var dueDate: Date
    var isCompleted: Bool
}
