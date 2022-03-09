//
//  Activity.swift
//  HabitTracking
//
//  Created by Andres camilo Raigoza misas on 8/03/22.
//

import Foundation
import SwiftUI

struct Activity: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let iconName: String
    let colorSelected: Color
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
