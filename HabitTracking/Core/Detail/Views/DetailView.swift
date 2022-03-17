//
//  DetailView.swift
//  HabitTracking
//
//  Created by Andres camilo Raigoza misas on 9/03/22.
//

import SwiftUI

struct DetailViewLoading: View {
    @ObservedObject var vm: ActivitiesModel
    @Binding var index: Int?
    
    var body: some View {
        ZStack {
            if let index = index {
                DetailView(vm: vm, index: index)
            }
        }
    }
}

struct DetailView: View {
    @ObservedObject var vm: ActivitiesModel
    let index: Int
    
    let currentWeek = Date.now.week
    @State private var currentWeekData = [Date: Int]()
    @State private var chartColor = Color.primary
    @State private var animateChart = false
    
    @State private var maxY = 0
    @State private var average = 0
    @State private var showTimeSetting = false
    
    var (red, green, blue, alpha): (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 1.0, 1.0)
        
    var body: some View {
        ScrollView {
            VStack {
                texts
                ChartView(
                    activity: vm.activities[index],
                    currentWeekData: currentWeekData,
                    maxY: maxY,
                    chartColor: chartColor,
                    animateChart: $animateChart
                )
                    .padding(.trailing, 5)
                    .padding(.bottom, 35)
                button
                Spacer()
            }
        }
        .navigationTitle(vm.activities[index].title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Image(systemName: vm.activities[index].iconName)
                .foregroundColor(Color(CGColor(red: red, green: green, blue: blue, alpha: alpha)))
        }
        .sheet(isPresented: $showTimeSetting) {
            NewValueSettingView(
                vm: vm,
                index: index,
                currentWeekData: $currentWeekData,
                animateChart: $animateChart)
        }
        .onAppear(perform: setValues)
        .onChange(of: vm.activities[index].data) { _ in
            setValues()
        }
    }
    private var goalAttributed: AttributedString {
        let goal = vm.activities[index].goal
        var string = AttributedString("Daily goal: \(goal) min")
        
        if let range = string.range(of: "\(goal)") {
            string[range].font = Font.title3.weight(.semibold)
        }
        return string
    }
    
    private var averageAttributed: AttributedString {
        var string = AttributedString("Average: \(average) min")
        if let range = string.range(of: "\(average)") {
            string[range].font = Font.title3.weight(.semibold)
        }
        return string
    }
    
    init(vm: ActivitiesModel, index: Int) {
        self.vm = vm
        self.index = index
        
        if let iconColor = vm.activities[index].iconColor {
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
        print("[😀] Detail view initialized for \(vm.activities[index].title)")
    }
}

struct DetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationView {
            DetailView(vm: ActivitiesModel(), index: 0)
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
                .padding(.bottom, 10)
            
            Text("Current Week:")
                .font(.headline)
            
            HStack {
                Text("\(goalAttributed),")
                Text(averageAttributed)
            }
        }
        .font(.callout)
        .padding()
        .padding(.bottom, 5)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    private var button: some View {
        Button("Set new value") {
            showTimeSetting = true
        }
        .font(.title3.weight(.regular))
    }
}

// MARK: - FUNCTIONS
extension DetailView {
    private func setValues() {
        // Initilize currentWeekData
        let data = vm.activities[index].data
        
        currentWeek.forEach { weekday in
            let dateFound = data.filter {$0.key.isSameDay(as: weekday)}
            
            if let date = dateFound.keys.first {
                // This weekday is already in data
                currentWeekData[date] = data[date]
            } else {
                // This weekday is not in data yet
                let olderDate = vm.activities[index].data.keys.min()
                
                if let olderDate = olderDate,
                   weekday.day > olderDate.day,
                   weekday.day <= Date.now.day {
                    
                    currentWeekData[weekday] = 0
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
        
        if percentageAverage > 0.9 {
            chartColor = .green
        } else if percentageAverage > 0.6 {
            chartColor = .orange
        } else {
            chartColor = .red
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.linear(duration: currentWeek.count > 3 ? 1.5 : 0.75)) {
                animateChart = true
            }
        }
    }
}
