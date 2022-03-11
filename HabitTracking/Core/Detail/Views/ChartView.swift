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
    @State private var dataDatesSorted: [Date] = []
    @State private var minDate = Date()
    @State private var maxDate = Date()
    @State private var maxY = 0
    @State private var chartColor = Color.primary
    @State private var animateChart = false
    @State private var geoWidth: CGFloat = 0
    @State private var weekdays = [Date]()
    @Binding var average: Int
    
    init(activity: Activity, average: Binding<Int>) {
        self.activity = activity
        goal = activity.goal
        self._average = average
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Spacer(minLength: 10)
                VStack {
                    HStack {
                        chartView
                            .background(yAxisDividers)
                            .frame(height: 250)
                        yAxisLabels
                    }
                    .frame(height: 273)
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
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(activity: dev.activities[2], average: .constant(50))
            .preferredColorScheme(.dark)
    }
}

extension ChartView {
    private var chartView: some View {
        GeometryReader { geo in
            Path { path in
                for index in weekdays.indices {
                    let yValue = data[weekdays[index], default: 0]
                    let yPosition = (1 - CGFloat(yValue) / CGFloat(maxY)) * geo.size.height
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: 0, y: yPosition))
                    }
                    
                    let xPosition = (geo.size.width / CGFloat(weekdays.count - 1)) * CGFloat(index)
                    if index < data.count {
                        path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                    }
                }
            }
            .trim(from: 0, to: animateChart ? 1.0 : 0.0)
            .stroke(chartColor,
                    style: .init(
                        lineWidth: data.count > 1 ? 2.5 : 5,
                        lineCap: .round,
                        lineJoin: .round)
            )
            .background {
                goalLine(geo: geo)
            }
            .background {
                xAxisDividers(geo: geo)
            }
            .onAppear {
                geoWidth = geo.size.width
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
        HStack {
            ForEach(weekdays, id: \.self) {
                Text($0, format: .dateTime.weekday())
                if $0 != weekdays.last {
                    Spacer(minLength: 0)
                }
            }
        }
        .frame(width: geoWidth + 8)
    }
    private var yAxisLabels: some View {
        VStack(alignment: .leading) {
            Text("\(maxY)")
            Spacer()
            Text("\(maxY * 2 / 3)")
                .offset(y: -6)
            Spacer()
            Text("\(maxY / 3)")
                .offset(y: -12)
            Spacer()
        }
    }
}

// MARK: - Functions
extension ChartView {
    private func setInitialValues() {
        data = activity.data
        let dates = [Date](data.keys)
        dataDatesSorted = dates.sorted()
        
        var maxValue = 0
        var total = 0
        var numberOfValues = 0
        
        if dataDatesSorted.count > 0 {
            if dataDatesSorted.count <= 7 {
                for index in dataDatesSorted.indices {
                    weekdays.append(dataDatesSorted[index])
                }
                if weekdays.count < 7 {
                    for _ in weekdays.count..<7 {
                        let lastDate = weekdays.last ?? Date.now
                        weekdays.append(lastDate.addingTimeInterval(24*60*60))
                    }
                }
                maxValue = data.values.max() ?? 0
                total = data.values.reduce(0, +)
                numberOfValues = data.count
            } else {
                // There's more than 7 days in data
                let firstDataDateIndex = dataDatesSorted.count - 8
                let lastDataDateIndex = dataDatesSorted.count - 1
                total = 0
                for index in firstDataDateIndex...lastDataDateIndex {
                    weekdays.append(dataDatesSorted[index])
                    total += data[dataDatesSorted[index]] ?? 0
                }
                total = weekdays.count
                let filteredData = data.filter { $0.key >= weekdays.first ?? Date.now }
                maxValue = filteredData.values.max() ?? 0
                numberOfValues = filteredData.count
            }
        } else {
            for i in 0..<7 {
                weekdays.append(Date.now.addingTimeInterval(TimeInterval(i*24*60*60)))
            }
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
            withAnimation(.linear(duration: 1)) {
                animateChart = true
            }
        }
    }
}
