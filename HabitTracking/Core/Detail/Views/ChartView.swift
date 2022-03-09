//
//  ChartView.swift
//  HabitTracking
//
//  Created by Andres camilo Raigoza misas on 9/03/22.
//

import SwiftUI

struct ChartView: View {
    let data: [Date:Int]
    let goal: Int
    let maxY: Int
    
    init(data: [Date:Int], goal: Int, maxY: Int) {
        self.data = data
        self.goal = goal
        let maxValue = data.values.max() ?? 0
        self.maxY = maxValue > goal ? maxValue : goal
    }
    
    var body: some View {
        GeometryReader { geo in
            Path { path in
                let dates = [Date](data.keys)
                let datesSorted = dates.sorted()
                
                for index in datesSorted.indices {
                    
                    let yValue = data[datesSorted[index], default: 0]
                    
                    let yPosition = (1 - CGFloat(yValue) / CGFloat(maxY)) * geo.size.height
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: 0, y: yPosition))
                    }
                    
                    let xPosition = (geo.size.width / CGFloat(data.count - 1)) * CGFloat(index)
                    
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            .stroke(.primary, style: .init(lineWidth: 3, lineCap: .round, lineJoin: .round))
            
        }
        .padding()
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(data: dev.activities[1].dailyData, goal: 150, maxY: dev.activities[1].dailyData.values.max() ?? 0)
    }
}
