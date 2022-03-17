//
//  ActivityRow.swift
//  HabitTracking
//
//  Created by Andres camilo Raigoza misas on 8/03/22.
//

import SwiftUI

struct ActivityRow: View {
    let activity: Activity
    var (red, green, blue, alpha): (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 1.0, 1.0)
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: activity.iconName)
                .font(.system(size: 40, weight: .light, design: .default))
                .foregroundColor(Color(CGColor(red: red, green: green, blue: blue, alpha: alpha)))
                .frame(width: 60)
            
            VStack(alignment: .leading, spacing: 3) {
                Text(activity.title)
                    .font(.title3.weight(.semibold))
                
                Text(activity.description)
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.callout.weight(.semibold))
                .foregroundColor(.secondary.opacity(0.8))
        }
        .contentShape(Rectangle())
    }
    
    init(activity: Activity) {
        self.activity = activity
        if let iconColor = activity.iconColor {
            iconColor.indices.forEach { index in
                switch index {
                case 0: red = iconColor[index]
                case 1: green = iconColor[index]
                case 2: blue = iconColor[index]
                case 3: alpha = iconColor[index]
                default: break
                }
            }
        }
    }
}

struct ActivityRow_Previews: PreviewProvider {
    static var previews: some View {
        ActivityRow(activity: dev.activity)
    }
}
