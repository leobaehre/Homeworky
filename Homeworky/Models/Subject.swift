//
//  Subject.swift
//  Homeworky
//
//  Created by Leo Bähre on 2/16/25.
//
import Foundation
import SwiftUI

struct Subject: Identifiable, Codable {
    var id = UUID()
    var name: String
    var colorHex: String // Store color as a hex string
    
    var color: Color {
        Color(hex: colorHex)
    }
}

extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0

        self.init(red: red, green: green, blue: blue)
    }
}
