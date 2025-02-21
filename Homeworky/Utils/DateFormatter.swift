//
//  DateFormatter.swift
//  Homeworky
//
//  Created by Leo Bähre on 2/15/25.
//

import Foundation

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
}()
