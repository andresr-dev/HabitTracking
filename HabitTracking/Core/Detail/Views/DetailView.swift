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
        VStack(spacing: 20) {
            Image(systemName: activity.iconName)
                .font(.system(size: 100, weight: .light, design: .default))
                .foregroundColor(activity.colorSelected)
            
            Text(activity.description)
                
            Spacer()
        }
        .padding()
        .navigationTitle(activity.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(activity: dev.activity)
        }
    }
}
