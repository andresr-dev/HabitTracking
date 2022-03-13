//
//  Date.swift
//  HabitTracking
//
//  Created by Andres camilo Raigoza misas on 11/03/22.
//

import Foundation

extension Date {
    var startOfWeek: Date {
        let components = Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return Calendar.current.date(from: components) ?? Date.now
    }
    func daysOfWeek() -> [Date] {
        var days = [Date]()
        for i in 0..<7 {
            days.append(Calendar.current.date(byAdding: .day, value: i, to: startOfWeek) ?? Date.now)
        }
        return days
    }
    func weekdayString() -> String {
        self.formatted(.dateTime.weekday())
    }
    func startOfDay() -> Date {
        Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self) ?? Date.now
    }
}


