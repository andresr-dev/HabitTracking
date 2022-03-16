//
//  ActivitiesModel.swift
//  HabitTracking
//
//  Created by Andres camilo Raigoza misas on 8/03/22.
//

import Foundation
import SwiftUI

final class ActivitiesModel: ObservableObject {
    @Published var activities = [Activity]() {
        didSet { saveToUserDefaults() } }
    
    init() {
        // This is needed for the previews
        //activities = DeveloperPreview.instance.activities
        if let dataSaved = UserDefaults.standard.data(forKey: "Activities") {
            if let decodedData = try? JSONDecoder().decode([Activity].self, from: dataSaved) {
                activities = decodedData
            }
        }
    }
    
    func saveToUserDefaults() {
        if let encodedData = try? JSONEncoder().encode(activities) {
            UserDefaults.standard.set(encodedData, forKey: "Activities")
        }
    }
    
    func addNewActivity(title: String, description: String, iconName: String, colorSelected: [CGFloat]?, goal: Int) {
        let newActivity = Activity(
            title: title,
            description: description,
            iconName: iconName,
            iconColor: colorSelected,
            goal: goal,
            data: [:]
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
    func setNewData(index: Int, date: Date, minutes: Int) {
        
        var data = activities[index].data
        // Detect if this day already exits in the array
        let dateFound = activities[index].data.keys.filter { $0.isSameDay(as: date) }
        
        if let dateFound = dateFound.first {
            // We are updating an existing date
            data[dateFound] = minutes
        } else {
            // This is a new date
            data[date] = minutes
        }
        let activityUpdated = activities[index].updateData(withData: data)
        activities[index] = activityUpdated
    }
}
