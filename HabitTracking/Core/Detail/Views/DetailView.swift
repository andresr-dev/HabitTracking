//
//  DetailView.swift
//  HabitTracking
//
//  Created by Andres camilo Raigoza misas on 9/03/22.
//

import SwiftUI

struct DetailView: View {
    @ObservedObject var vm: ActivitiesModel
    let index: Int
    
    let currentWeek = Date.now.week
    @State private var currentWeekData = [Date: Int]()
    @State private var chartColor = Color.primary
    
    @State private var maxY = 0
    @State private var average = 0
    @State private var showTimeSetting = false
    
    private var averageAttributed: AttributedString {
        var string = AttributedString("Average: \(average) min")
        let range = string.range(of: "\(average)")!
        string[range].font = Font.title3.weight(.semibold)
        return string
    }
    
    var body: some View {
        VStack {
            texts
            ChartView(activity: vm.activities[index], currentWeekData: currentWeekData, maxY: maxY, chartColor: chartColor)
                .padding(.trailing, 5)
                .padding(.bottom, 45)
            button
            Spacer()
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .navigationTitle(vm.activities[index].title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Image(systemName: vm.activities[index].iconName)
                .foregroundColor(vm.activities[index].iconColor)
        }
        .sheet(isPresented: $showTimeSetting) {
            NewValueSettingView(currentWeekData: $currentWeekData)
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(vm: ActivitiesModel(), index: 1)
        }
        .preferredColorScheme(.dark)
    }
}

extension DetailView {
    private var texts: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Description:")
                .font(.headline)
            
            Text(vm.activities[index].description)
                .font(.callout)
                .padding(.bottom, 10)
            
            Text(averageAttributed)
                .font(.callout)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    private var button: some View {
        Button("Set new value") {
            showTimeSetting = true
        }
        .font(.title3.weight(.medium))
    }
}

// MARK: - FUNCTIONS
extension DetailView {
    private func setInitialValues() {
        // Initilize currentWeekData
        currentWeek.indices.forEach { currentWeekIndex in
            // find the days of week that match with activity data
            let data = vm.activities[index].data.filter { $0.key.isSameDay(as: currentWeek[currentWeekIndex])}
            
            if let date = data.keys.first {
                currentWeekData[date] = vm.activities[index].data[date]
            } else {
                // Check if this date is grater than the older date
                if let olderDate = vm.activities[index].data.keys.min(),
                    currentWeek[currentWeekIndex].day > olderDate.day,
                    let newestDate = vm.activities[index].data.keys.max(),
                    currentWeek[currentWeekIndex].day < newestDate.day {
                    currentWeekData[currentWeek[currentWeekIndex]] = 0
                }
            }
        }
        print("[😀] Current week data: \(currentWeekData)")
        
        // Calculate average
        let values = currentWeekData.map({ $0.value })
        let total = values.reduce(0, +)
        let numberOfValues = currentWeekData.count
        let goal = vm.activities[index].goal
        
        maxY = goal
        if let maxValue = values.max(), maxValue > maxY {
            maxY = maxValue
        }
        average = numberOfValues > 0 ? total / numberOfValues : 0
        
        let percentageAverage = Double(average) / Double(goal)
        
        if percentageAverage >= 1 {
            chartColor = .green
        } else if percentageAverage > 0.7 {
            chartColor = .orange
        } else {
            chartColor = .red
        }
    }
}
