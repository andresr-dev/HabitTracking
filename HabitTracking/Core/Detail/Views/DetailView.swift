//
//  DetailView.swift
//  HabitTracking
//
//  Created by Andres camilo Raigoza misas on 9/03/22.
//

import SwiftUI

struct DetailView: View {
    let activity: Activity
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text(activity.description)
            
//            Text("Performance:")
//                .font(.title3.weight(.semibold))
            
            ChartView(activity: activity)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
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
