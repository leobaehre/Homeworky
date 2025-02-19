//
//  Homework.swift
//  Homeworky
//
//  Created by Leo Bähre on 2/15/25.
//

import Foundation

struct Homework: Identifiable {
    let id = UUID()
    var subject: String
    var title: String
    var dueDate: Date
    var isCompleted: Bool
}
