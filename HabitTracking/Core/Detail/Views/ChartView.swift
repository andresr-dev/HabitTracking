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
    @State private var data: [Date: Int] = [:]
    @State private var datesSorted: [Date] = []
    @State private var minDate = Date()
    @State private var maxDate = Date()
    @State private var maxY = 0
    @State private var chartColor = Color.primary
    @State private var average = 0
    @State private var animateChart = false
    
    init(activity: Activity) {
        self.activity = activity
        goal = activity.goal
    }
    
    var body: some View {
        VStack {
            chartView
                .frame(height: 250)
                .background(chartBackground)
                .overlay(chartYAxis, alignment: .leading)
            chartDateLabels
            averageText
        }
        .font(.callout)
        .foregroundColor(.secondary)
        .onAppear {
            setInitialValues()
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(activity: dev.activities[1])
            .preferredColorScheme(.dark)
    }
}

extension ChartView {
    private var averageText: some View {
        Text("Your average is \(average) min")
            .font(.headline.weight(.medium))
            .foregroundColor(.primary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 10)
    }
    private var chartView: some View {
        GeometryReader { geo in
            Path { path in
                for index in datesSorted.indices {
                    let yValue = data[datesSorted[index], default: 0]
                    let yPosition = (1 - CGFloat(yValue) / CGFloat(maxY)) * geo.size.height
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: 0, y: yPosition))
                    }
                    let xAxisDivisions = data.count > 1 ? data.count - 1 : 1
                    let xPosition = (geo.size.width / CGFloat(xAxisDivisions)) * CGFloat(index)
                                        
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            .trim(from: 0, to: animateChart ? 1.0 : 0.0)
            .stroke(chartColor,
                    style: .init(
                        lineWidth: data.count > 1 ? 3 : 7,
                        lineCap: .round,
                        lineJoin: .round)
            )
            .overlay {
                Path { path in
                    let yPosition = (1 - (CGFloat(goal) / CGFloat(maxY))) * geo.size.height
                    
                    path.move(to: CGPoint(x: 0, y: yPosition))
                    path.addLine(to: CGPoint(x: geo.size.width, y: yPosition))
                }
                .stroke(.blue, style: StrokeStyle(lineWidth: 1, lineCap: .round))
            }
        }
    }
    private var chartBackground: some View {
        VStack {
            Divider()
            Spacer()
            Divider()
                .padding(.leading, 52)
            Spacer()
            Divider()
        }
    }
    private var chartYAxis: some View {
        VStack(alignment: .leading) {
            Text("\(maxY) min")
            Spacer()
            Text("\(maxY / 2) min")
            Spacer()
            Text("0 min")
        }
    }
    private var chartDateLabels: some View {
        HStack {
            Text(minDate.formatted(date: .abbreviated, time: .omitted))
            Spacer()
            Text(maxDate.formatted(date: .abbreviated, time: .omitted))
        }
    }
}

// MARK: - Functions
extension ChartView {
    private func setInitialValues() {
        data = activity.data
        let dates = [Date](data.keys)
        datesSorted = dates.sorted()
        
        var maxValue = 0
        var total = 0
        var numberOfValues = 0
        
        if datesSorted.count > 0 {
            if datesSorted.count >= 2 && datesSorted.count <= 7 {
                minDate = datesSorted.min() ?? Date()
                maxDate = datesSorted.max() ?? Date()
                maxValue = data.values.max() ?? 0
                total = data.values.reduce(0, +)
                numberOfValues = data.count
            } else if datesSorted.count == 1 {
                minDate = datesSorted.first ?? Date()
                if minDate.addingTimeInterval(24*60*60) > Date() {
                    maxDate = minDate.addingTimeInterval(24*60*60)
                } else {
                    maxDate = Date()
                }
                maxValue = data.values.first ?? 0
                total = maxValue
                numberOfValues = 1
            } else {
                // There's more than 7 days in data
                maxDate = datesSorted.max() ?? Date()
                let lastIndex = datesSorted.lastIndex(of: maxDate)
                minDate = datesSorted[(lastIndex ?? 0) - 7]
                let filteredData = data.filter { $0.key >= minDate }
                maxValue = filteredData.values.max() ?? 0
                total = filteredData.values.reduce(0, +)
                numberOfValues = filteredData.count
            }
        } else {
            minDate = Date()
            maxDate = minDate.addingTimeInterval(24*60*60)
        }
        
        maxY = maxValue > goal ? maxValue : goal
        average = numberOfValues > 0 ? total / numberOfValues : 0
        
        let percentageAverage = Double(average) / Double(goal)
        
        if percentageAverage >= 1 {
            chartColor = .green
        } else if percentageAverage >= 0.8 {
            chartColor = .orange
        } else {
            chartColor = .red
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.linear(duration: 1.5)) {
                animateChart = true
            }
        }
    }
}
