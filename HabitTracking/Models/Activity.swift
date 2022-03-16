//
//  Activity.swift
//  HabitTracking
//
//  Created by Andres camilo Raigoza misas on 8/03/22.
//

import Foundation
import SwiftUI

struct Activity: Identifiable, Codable {
    var id = UUID()
    let title: String
    let description: String
    let iconName: String
    let iconColor: [CGFloat]?
    let goal: Int
    let data: [Date:Int]
    
    func updateData(withData: [Date: Int]) -> Activity {
        Activity(title: title, description: description, iconName: iconName, iconColor: iconColor, goal: goal, data: withData)
    }
}

enum ActivityIcon: String, CaseIterable {
    case piano = "pianokeys.inverse"
    case computer = "laptopcomputer"
    case idea = "lightbulb.fill"
    case learn = "graduationcap.fill"
    case read = "book.fill"
    case music = "music.note.list"
    case draw = "pencil.and.outline"
    case paint = "paintpalette"
    case brain = "brain.head.profile"
    case walk = "figure.walk"
    case camera = "camera"
    case write = "highlighter"
}
