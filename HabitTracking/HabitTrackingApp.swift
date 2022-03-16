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
        appearance.backgroundColor = UIColor.secondarySystemBackground
        
        UINavigationBar.appearance().compactAppearance = appearance
        //UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactScrollEdgeAppearance = appearance
    }
    
    var body: some Scene {
        WindowGroup {
            ActivitiesListView()
        }
    }
}
