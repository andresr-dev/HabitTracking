//
//  DetailView.swift
//  HabitTracking
//
//  Created by Andres camilo Raigoza misas on 9/03/22.
//

import SwiftUI

struct DetailView: View {
    let activity: Activity
    @State private var average = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text(activity.description)
            ChartView(activity: activity, average: $average)
            Text("Your average this week is \(average) min")
                .font(.headline.weight(.medium))
                .foregroundColor(.primary)
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
            .navigationTitle(activity.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Image(systemName: activity.iconName)
                    .foregroundColor(activity.iconColor)
            }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(activity: dev.activities[1])
        }
        .preferredColorScheme(.dark)
    }
}
