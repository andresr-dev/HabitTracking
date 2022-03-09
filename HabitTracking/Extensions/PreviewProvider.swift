//
//  PreviewProvider.swift
//  HabitTracking
//
//  Created by Andres camilo Raigoza misas on 9/03/22.
//

import Foundation
import SwiftUI

extension PreviewProvider {
    static var dev: DeveloperPreview {
        DeveloperPreview.instance
    }
}

struct DeveloperPreview {
    static let instance = DeveloperPreview()
    private init() { }
    
    let activity = Activity(
        title: "Learn Piano",
        description: "Study piano for 1 hour daily",
        iconName: ActivityIcon.piano.rawValue,
        colorSelected: .purple
    )
    let activities = [
        Activity(
            title: "Walk",
            description: "Walk every day for 1 hour",
            iconName: ActivityIcon.walk.rawValue,
            colorSelected: .green
        ),
        Activity(
            title: "Learn Piano",
            description: "Study piano for 1 hour daily",
            iconName: ActivityIcon.piano.rawValue,
            colorSelected: .purple
        ),
        Activity(
            title: "Learn Programing",
            description: "Study programing for 3 hours daily",
            iconName: ActivityIcon.brain.rawValue,
            colorSelected: .orange
        )
    ]
}
