//
//  ChartView.swift
//  HabitTracking
//
//  Created by Andres camilo Raigoza misas on 9/03/22.
//

import SwiftUI

struct ChartView: View {
    let activity: Activity
    let currentWeek: [Date]
    
    var currentWeekData = [Date: Int]()
    var todayIndex = 0
    
    @State private var maxY = 0
    @State private var chartColor = Color.primary
    @State private var animateChart = false
    
    @State private var geoWidth: CGFloat = 0
    @State private var geoHeight: CGFloat = 230
    
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
            chartDetails
        }
        .font(.callout)
        .foregroundColor(.secondary)
        .onAppear {
            setInitialValues()
        }
    }
    init(activity: Activity, average: Binding<Int>) {
        self.activity = activity
        self._average = average
        
        currentWeek = Date.now.week
        print("[😀] current week: \(currentWeek)")
        
        currentWeek.indices.forEach { index in
            // find the days of week that match with activity data
            let data = activity.data.filter { $0.key.isSameDay(as: currentWeek[index])}
            
            if let date = data.keys.first {
                currentWeekData[date] = activity.data[date]
            } else {
                // Check if this date is grater than the older date
                if let olderDate = activity.data.keys.min(), currentWeek[index] > olderDate && currentWeek[index] < Date.now {
                    currentWeekData[currentWeek[index]] = 0
                }
            }
            
            // find today index in current week
            if Date.now.isSameDay(as: currentWeek[index]) {
                todayIndex = index
            }
        }
        print("[😀] Current week data: \(currentWeekData)")
        print("[😀] Today index: \(todayIndex)")
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(activity: dev.activities[1], average: .constant(50))
            .preferredColorScheme(.dark)
            .previewInterfaceOrientation(.portrait)
    }
}

extension ChartView {
    private var chartView: some View {
        GeometryReader { geo in
            Path { path in
                for index in currentWeek.indices {
                    
                    // find the value corresponding to the same day
                    let date = currentWeekData.filter({ $0.key.isSameDay(as: currentWeek[index]) }).keys.first
                    
                    let tomorrow = Date.now.addingTimeInterval(24*60*60)
                    
                    let yValue = currentWeekData[date ?? tomorrow, default: 0]
                    
                    let xPosition = (geo.size.width / CGFloat(currentWeek.count - 1)) * CGFloat(index)
                    
                    let yPosition = (1 - CGFloat(yValue) / CGFloat(maxY)) * geo.size.height
                                        
                    if date == currentWeekData.keys.sorted().first {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }
                    if date != nil {
                        path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                    }
                }
            }
            .trim(from: 0, to: animateChart ? 1.0 : 0.0)
            .stroke(chartColor,
                    style: .init(
                        lineWidth: currentWeekData.count == 1 && Date.now.isSameDay(as: currentWeekData.keys.first!) ? 5 : 2.5,
                        lineCap: .round,
                        lineJoin: .round)
            )
            .shadow(color: chartColor.opacity(0.8), radius: 10, x: 0, y: 3)
            .shadow(color: chartColor.opacity(0.3), radius: 10, x: 0, y: 3)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
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
            for index in currentWeek.indices {
                let xPosition = (geo.size.width / CGFloat(currentWeek.count - 1)) * CGFloat(index)
                path.move(to: CGPoint(x: xPosition, y: geo.size.height))
                path.addLine(to: CGPoint(x: xPosition, y: 0))
            }
        }
        .stroke(Color.primary.opacity(0.5), style: StrokeStyle(lineWidth: 0.5, dash: [3, 5], dashPhase: 2))
    }
    private var yAxisDividers: some View {
        VStack {
            Rectangle()
                .fill(Color.primary.opacity(0.4))
                .frame(height: 0.5)
            Spacer()
            
            Rectangle()
                .fill(Color.primary.opacity(0.4))
                .frame(height: 0.5)
            Spacer()
            
            Rectangle()
                .fill(Color.primary.opacity(0.4))
                .frame(height: 0.5)
            Spacer()
            
            Rectangle()
                .fill(Color.primary.opacity(0.4))
                .frame(height: 0.5)
        }
    }
    private func goalLine(geo: GeometryProxy) -> some View {
        Path { path in
            let yPosition = (1 - (CGFloat(activity.goal) / CGFloat(maxY))) * geo.size.height
            
            path.move(to: CGPoint(x: 0, y: yPosition))
            path.addLine(to: CGPoint(x: geo.size.width, y: yPosition))
        }
        .stroke(.blue, style: StrokeStyle(lineWidth: 1, lineCap: .round))
    }
    private var xAxisLabels: some View {
        HStack {
            ForEach(currentWeek, id: \.self) {
                Text($0.weekdayString)
                    .frame(maxWidth: .infinity)
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
    private var chartDetails: some View {
        HStack(spacing: 0) {
            HStack(spacing: 6) {
                Rectangle()
                    .fill(.blue)
                    .frame(width: 12, height: 6)
                Text("Goal")
            }
            Spacer(minLength: 0)
            HStack(spacing: 6) {
                Rectangle()
                    .fill(.green)
                    .frame(width: 12, height: 6)
                Text("High Av.")
            }
            Spacer(minLength: 0)
            HStack(spacing: 6) {
                Rectangle()
                    .fill(.orange)
                    .frame(width: 12, height: 6)
                Text("Med. Av.")
            }
            Spacer(minLength: 0)
            HStack(spacing: 6) {
                Rectangle()
                    .fill(.red)
                    .frame(width: 12, height: 6)
                Text("Low Av.")
            }
        }
        .frame(width: geoWidth > 0 ? geoWidth - 18 : 0, alignment: .trailing)
        .padding(.leading, geoWidth / 18)
        .padding(.top, -5)
    }
}

// MARK: - Functions
extension ChartView {
    private func setInitialValues() {
        // Calculate average
        let values = currentWeekData.map({ $0.value })
        let total = values.reduce(0, +)
        let numberOfValues = currentWeekData.count
        
        maxY = activity.goal
        if let maxValue = values.max(), maxValue > maxY {
            maxY = maxValue
        }
        average = numberOfValues > 0 ? total / numberOfValues : 0
        
        let percentageAverage = Double(average) / Double(activity.goal)
        
        if percentageAverage >= 1 {
            chartColor = .green
        } else if percentageAverage > 0.7 {
            chartColor = .orange
        } else {
            chartColor = .red
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.linear(duration: currentWeekData.count > 3 ? 1.5: 0.8)) {
                animateChart = true
            }
        }
    }
}
