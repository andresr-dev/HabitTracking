//
//  ActivitiesModel.swift
//  HabitTracking
//
//  Created by Andres camilo Raigoza misas on 8/03/22.
//

import Foundation

final class ActivitiesModel: ObservableObject {
    @Published var activities = [Activity]()
    
    init() {
        activities = DeveloperPreview.instance.activities
    }
}