//
//  Date.swift
//  HabitTracking
//
//  Created by Andres camilo Raigoza misas on 11/03/22.
//

import Foundation

extension Date {
    var weekdayString: String {
        self.formatted(.dateTime.weekday())
    }
    var day: Int {
        let calendar = Calendar.current
        return calendar.dateComponents([.day], from: self).day ?? 0
    }
    var displayDay: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter.string(from: self)
    }
    var week: [Date] {
        let calendar = Calendar.current
        let week = calendar.dateInterval(of: .weekOfMonth, for: self)
        var weekDates = [Date]()
        
        guard let firstDay = week?.start else {
            return weekDates
        }
        (0..<7).forEach { day in
            if let weekDay = calendar.date(byAdding: .day, value: day, to: firstDay) {
                weekDates.append(weekDay)
            }
        }
        return weekDates
    }
    var isDateToday: Bool {
        let calendar = Calendar.current
        return calendar.isDateInToday(self)
    }
    func weekString(week: [Date]) -> [String] {
        var weekString = [String]()
        week.forEach { day in
            weekString.append(day.weekdayString)
        }
        return weekString
    }
    func isSameDay(as date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date, inSameDayAs: self)
    }
}


