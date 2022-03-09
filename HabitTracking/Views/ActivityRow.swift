//
//  ActivityRow.swift
//  HabitTracking
//
//  Created by Andres camilo Raigoza misas on 8/03/22.
//

import SwiftUI

struct ActivityRow: View {
    let activity: Activity
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: activity.iconName)
                .font(.system(size: 42, weight: .semibold, design: .default))
                .foregroundColor(activity.colorSelected)
            
            VStack(alignment: .leading, spacing: 3) {
                Text(activity.title)
                    .font(.title3.weight(.semibold))
                
                Text(activity.description)
                    .font(.callout)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct ActivityRow_Previews: PreviewProvider {
    static var previews: some View {
        ActivityRow(activity: Activity(title: "Learn Piano", description: "Attend daily lessons", iconName: "pianokeys.inverse", colorSelected: .green))
    }
}
