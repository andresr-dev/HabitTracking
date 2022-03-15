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
    @State private var showTimeSetting = false
    @State private var minutesSelected = 0
    
    private var averageAttributed: AttributedString {
        var string = AttributedString("Average: \(average) min")
        let range = string.range(of: "\(average)")!
        string[range].font = Font.title3.weight(.semibold)
        return string
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                texts
                ChartView(activity: activity, average: $average)
                    .padding(.trailing, 5)
                    .padding(.bottom, 45)
                button
                Spacer()
            }
            if showTimeSetting {
//                TimeSettingCard(minutesSelected: $minutesSelected, showCard: $showTimeSetting)
//                    .transition(.move(edge: .bottom))
            }
        }
        .ignoresSafeArea(.container, edges: .bottom)
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

extension DetailView {
    private var texts: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Description:")
                .font(.headline)
            
            Text(activity.description)
                .font(.callout)
                .padding(.bottom, 10)
            
            Text(averageAttributed)
                .font(.callout)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    private var button: some View {
        Button("Set today's time") {
            withAnimation(.easeInOut) {
                showTimeSetting = true
            }
        }
        .font(.title3.weight(.medium))
    }
}
