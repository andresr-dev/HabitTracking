//
//  HabitTrackingApp.swift
//  HabitTracking
//
//  Created by Andres camilo Raigoza misas on 8/03/22.
//

import SwiftUI

@main
struct HabitTrackingApp: App {
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.clear
        
        UINavigationBar.appearance().compactAppearance = appearance
    }
    
    var body: some Scene {
        WindowGroup {
            ActivitiesListView()
        }
    }
}
