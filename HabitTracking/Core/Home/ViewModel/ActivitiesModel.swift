//
//  ActivitiesModel.swift
//  HabitTracking
//
//  Created by Andres camilo Raigoza misas on 8/03/22.
//

import Foundation
import SwiftUI

final class ActivitiesModel: ObservableObject {
    @Published var activities = [Activity]()
    
    init() {
        activities = DeveloperPreview.instance.activities
    }
    
    func addNewActivity(title: String, description: String, iconName: String, colorSelected: Color, goal: Int) {
        let newActivity = Activity(
            title: title,
            description: description,
            iconName: iconName,
            colorSelected: colorSelected,
            dailyGoal: goal,
            dailyData: [:]
        )
        withAnimation {
            activities.append(newActivity)
        }
    }
    func delete(at offsets: IndexSet) {
        activities.remove(atOffsets: offsets)
    }
    func move(fromOffsets: IndexSet, toOffset: Int) {
        activities.move(fromOffsets: fromOffsets, toOffset: toOffset)
    }
}
