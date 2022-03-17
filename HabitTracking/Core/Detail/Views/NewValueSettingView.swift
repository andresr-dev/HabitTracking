//
//  setTodayValueView.swift
//  HabitTracking
//
//  Created by Andres camilo Raigoza misas on 13/03/22.
//

import SwiftUI

struct NewValueSettingView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var vm: ActivitiesModel
    let index: Int
    
    let currentWeek = Date.now.week
    @Binding var currentWeekData: [Date: Int]
    
    var today: Date {
        currentWeek.filter({ $0.isDateToday }).first ?? Date.now
    }
    
    @Binding var animateChart: Bool
    
    @State var minutesSelected = 0
    @State var dateSelected = Date()
    
    var body: some View {
        VStack(spacing: 50) {
            title
            weekdays
            minutesPicker
            Spacer()
            saveButton
        }
        .overlay(alignment: .topTrailing) {
            xButton
        }
        .padding()
        .onAppear {
            setMinutesSelected(initilizeDateSelected: true)
        }
    }
}

struct NewValueSettingView_Previews: PreviewProvider {
    static var previews: some View {
        NewValueSettingView(vm: ActivitiesModel(), index: 1, currentWeekData: .constant(dev.activities[0].data), animateChart: .constant(false))
            .preferredColorScheme(.dark)
    }
}

extension NewValueSettingView {
    private var title: some View {
        Text("Current Week")
            .font(.title.weight(.semibold))
            .padding(.top, 20)
    }
    private var weekdays: some View {
        HStack {
            ForEach(currentWeek, id: \.self) { weekday in
                Text(weekday.displayDay(
                    longFormat: dateSelected.isSameDay(as: weekday),
                    isToday: today.isSameDay(as: weekday))
                )
                    .fontWeight(dateSelected.isSameDay(as: weekday) ? .bold : .regular)
                    .foregroundColor(weekday.day > today.day ? Color.secondary.opacity(0.5) : Color.primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, dateSelected.isSameDay(as: weekday) ? 7 : 0)
                    .background {
                        Capsule()
                            .fill(.thinMaterial)
                            .environment(\.colorScheme, .light)
                            .opacity(dateSelected.isSameDay(as: weekday) ? 0.8 : 0)
                    }
                    .frame(width: dateSelected.isSameDay(as: weekday) ? 140 : nil)
                    .onTapGesture {
                        withAnimation {
                            dateSelected = weekday
                        }
                        setMinutesSelected()
                    }
                    .disabled(weekday.day > Date.now.day)
            }
        }
    }
    private var minutesPicker: some View {
        Picker("Select value in minutes", selection: $minutesSelected) {
            ForEach(0..<301) { minute in
                Text("\(minute) min")
                    .tag(minute)
            }
        }
        .pickerStyle(.wheel)
    }
    private var saveButton: some View {
        Button(action: saveButtonPressed) {
            Text("Save")
                .font(.title3.weight(.semibold))
                .foregroundColor(.white)
                .frame(height: 52)
                .frame(maxWidth: .infinity)
                .background(.blue)
                .cornerRadius(12)
                .padding(.horizontal)
        }
    }
    private var xButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
        }
        .font(.title3.weight(.medium))
        .tint(.primary)
    }
}
// MARK: - FUNCTIONS
extension NewValueSettingView {
    private func saveButtonPressed() {
        animateChart = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            vm.setNewData(index: index, date: dateSelected, minutes: minutesSelected)
            dismiss()
        }
    }
    private func setMinutesSelected(initilizeDateSelected: Bool = false) {
        
        if initilizeDateSelected {
            if let date = currentWeek.filter({ $0.isDateToday }).first {
                dateSelected = date
            }
        }
        
        // Read the minutes so the wheel shows the minutes related with the date
        let data = vm.activities[index].data
        
        let dateFound = data.keys.filter {$0.isSameDay(as: dateSelected)}
        
        if let dateFound = dateFound.first {
            minutesSelected = data[dateFound, default: 0]
        } else {
            minutesSelected = 0
        }
    }
}
