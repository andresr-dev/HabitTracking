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
        HStack(spacing: 10) {
            Image(systemName: activity.iconName)
                .font(.system(size: 40, weight: .light, design: .default))
                .foregroundColor(activity.iconColor)
                .frame(width: 60)
            
            VStack(alignment: .leading, spacing: 3) {
                Text(activity.title)
                    .font(.title3.weight(.semibold))
                
                Text(activity.description)
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
        }
    }
}

struct ActivityRow_Previews: PreviewProvider {
    static var previews: some View {
        ActivityRow(activity: dev.activity)
    }
}
