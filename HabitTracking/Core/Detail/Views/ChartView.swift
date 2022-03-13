//
//  ChartView.swift
//  HabitTracking
//
//  Created by Andres camilo Raigoza misas on 9/03/22.
//

import SwiftUI

struct ChartView: View {
    let activity: Activity
    let goal: Int
    let todayNumber: Int
    var datesOfWeek = [Date]()
    var weekdays = [String]()
    
    @State private var dataOfWeek = [String: Int]()
    
    @State private var maxY = 0
    @State private var chartColor = Color.primary
    @State private var animateChart = false
    @State private var geoWidth: CGFloat = 0
    @State private var geoHeight: CGFloat = 250
    
    @Binding var average: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer(minLength: geoWidth / 18)
                VStack {
                    HStack(alignment: .bottom) {
                        chartView
                            .frame(height: geoHeight)
                            .background(yAxisDividers)
                        yAxisLabels
                    }
                    
                }
            }
            xAxisLabels
        }
        .font(.callout)
        .foregroundColor(.secondary)
        .onAppear {
            setInitialValues()
        }
    }
    init(activity: Activity, average: Binding<Int>) {
        self.activity = activity
        goal = activity.goal
        self._average = average
        todayNumber = Calendar.current.dateComponents([.day], from: Date.now).day ?? 0
        
        let firstDayChart = Calendar.current.date(byAdding: .day, value: -6, to: Date.now.startOfDay()) ?? Date.now
        
        for i in 0..<7 {
            datesOfWeek.append(Calendar.current.date(byAdding: .day, value: i, to: firstDayChart) ?? Date.now)
        }
        print("[😀] dates of week initializacion: \(datesOfWeek)")
        for date in datesOfWeek {
            weekdays.append(date.formatted(.dateTime.weekday()))
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(activity: dev.activities[1], average: .constant(50))
            .preferredColorScheme(.dark)
    }
}

extension ChartView {
    private var chartView: some View {
        GeometryReader { geo in
            Path { path in
                let firstDataDate = activity.data.keys.min() ?? Date.now
                let firstDataDay = Calendar.current.dateComponents([.day], from: firstDataDate).day ?? 0
                
                let firstChartDay = Calendar.current.dateComponents([.day], from: datesOfWeek.first ?? Date.now).day ?? 0
                
                print("first data day: \(firstDataDay)")
                print("first date day: \(firstChartDay)")
                
                for index in weekdays.indices {
                    let yValue = dataOfWeek[weekdays[index], default: 0]
                    
                    let xPosition = (geo.size.width / CGFloat(weekdays.count - 1)) * CGFloat(index)
                    
                    let yPosition = (1 - CGFloat(yValue) / CGFloat(maxY)) * geo.size.height
                    
                    let chartDay = Calendar.current.dateComponents([.day], from: datesOfWeek[index]).day ?? 0
                    
                    if chartDay == firstDataDay || firstChartDay > firstDataDay {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }
                    if chartDay >= firstDataDay && chartDay <= todayNumber {
                        path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                    }
                }
                print("days of week: \(weekdays)")
                print("data of week: \(dataOfWeek)")
            }
            .trim(from: 0, to: animateChart ? 1.0 : 0.0)
            .stroke(chartColor,
                    style: .init(
                        lineWidth: dataOfWeek.count > 1 ? 2.5 : 5,
                        lineCap: .round,
                        lineJoin: .round)
            )
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    geoWidth = geo.size.width
                }
            }
            .background {
                goalLine(geo: geo)
            }
            .background {
                xAxisDividers(geo: geo)
            }
        }
    }
    private func xAxisDividers(geo: GeometryProxy) -> some View {
        Path { path in
            for index in weekdays.indices {
                let xPosition = (geo.size.width / CGFloat(weekdays.count - 1)) * CGFloat(index)
                path.move(to: CGPoint(x: xPosition, y: geo.size.height))
                path.addLine(to: CGPoint(x: xPosition, y: 0))
            }
        }
        .stroke(Color.primary.opacity(0.5), style: StrokeStyle(lineWidth: 0.5, dash: [3, 5], dashPhase: 0))
    }
    private var yAxisDividers: some View {
        VStack {
            Rectangle()
                .frame(height: 0.5)
            Spacer()
            Rectangle()
                .frame(height: 0.5)
            Spacer()
            Rectangle()
                .frame(height: 0.5)
            Spacer()
            Rectangle()
                .frame(height: 0.5)
        }
        .foregroundColor(Color.primary.opacity(0.5))
    }
    private func goalLine(geo: GeometryProxy) -> some View {
        Path { path in
            let yPosition = (1 - (CGFloat(goal) / CGFloat(maxY))) * geo.size.height
            
            path.move(to: CGPoint(x: 0, y: yPosition))
            path.addLine(to: CGPoint(x: geo.size.width, y: yPosition))
        }
        .stroke(.blue, style: StrokeStyle(lineWidth: 1, lineCap: .round))
    }
    private var xAxisLabels: some View {
        HStack(spacing: 0) {
            ForEach(weekdays, id: \.self) {
                Text($0)
                    .frame(width: (geoWidth / 9))
                if $0 != weekdays.last {
                    Spacer(minLength: 0)
                }
            }
        }
        .frame(width: geoWidth + (geoWidth / 18))
    }
    private var yAxisLabels: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("\(maxY)")
                .frame(height: geoHeight / 6)
            
            Spacer(minLength: 0)
            
            Text("\(maxY * 2 / 3)")
                .frame(height: geoHeight / 6)
            
            Spacer(minLength: 0)
            
            Text("\(maxY / 3)")
                .frame(height: geoHeight / 6)
            
            Spacer(minLength: 0)
        }
        .frame(height: geoHeight)
        .offset(y: -(geoHeight / 12))
    }
}

// MARK: - Functions
extension ChartView {
    private func setInitialValues() {
        let data = activity.data.filter { $0.key >= datesOfWeek.first ?? Date.now }
        
        // Create two arrays, one with the dates sorted and other with its values
        var datesOfWeekFromData = data.map({ $0.key }).sorted()
        
        if datesOfWeekFromData.count > 0 {
            print("dates of week from data: \(datesOfWeekFromData)")
            
            var lastDayOfWeekFromData = Calendar.current.dateComponents([.day], from: datesOfWeekFromData.last ?? Date.now).day ?? 0
            
            while todayNumber > lastDayOfWeekFromData {
                datesOfWeekFromData.append(Calendar.current.date(byAdding: .day, value: 1, to: datesOfWeekFromData.last ?? Date.now) ?? Date.now)
               
                lastDayOfWeekFromData = Calendar.current.dateComponents([.day], from: datesOfWeekFromData.last ?? Date.now).day ?? 0
            }
            print("dates of week from data until today: \(datesOfWeekFromData)")
        }
        
        var valuesOfWeek = [Int]()
        for date in datesOfWeekFromData {
            valuesOfWeek.append(data[date, default: 0])
        }
        
        // Convert dates sorted to its respective weekday string
        var weekdaysFromData = [String]()
        for date in datesOfWeekFromData {
            weekdaysFromData.append(date.formatted(.dateTime.weekday()))
        }
        
        // Mix weekdays and values to fill dataOfWeek
        for index in weekdaysFromData.indices {
            dataOfWeek[weekdaysFromData[index]] = valuesOfWeek[index]
        }
        print("data of week: \(dataOfWeek)")
        
        // Calculate average
        let maxValue = valuesOfWeek.max() ?? 0
        let total = valuesOfWeek.reduce(0, +)
        let numberOfValues = valuesOfWeek.count
        
        maxY = maxValue > goal ? maxValue : goal
        average = numberOfValues > 0 ? total / numberOfValues : 0
        
        let percentageAverage = Double(average) / Double(goal)
        if percentageAverage >= 1 {
            chartColor = .green
        } else if percentageAverage > 0.7 {
            chartColor = .orange
        } else {
            chartColor = .red
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.linear(duration: dataOfWeek.count > 3 ? 1.5: 0.8)) {
                animateChart = true
            }
        }
    }
}
