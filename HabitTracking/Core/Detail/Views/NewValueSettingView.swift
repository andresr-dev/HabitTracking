//
//  setTodayValueView.swift
//  HabitTracking
//
//  Created by Andres camilo Raigoza misas on 13/03/22.
//

import SwiftUI

struct NewValueSettingView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var currentWeekData: [Date: Int]
    
    let currentWeek = Date.now.week
    @State private var daySelected = Date()
    @State private var minutesSelected = 0
    
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
    }
}

struct NewValueSettingView_Previews: PreviewProvider {
    static var previews: some View {
        NewValueSettingView(currentWeekData: .constant(dev.activities[0].data))
            .preferredColorScheme(.dark)
    }
}

extension NewValueSettingView {
    private var title: some View {
        Text("Set new value")
            .font(.title.weight(.semibold))
            .padding(.top)
    }
    private var weekdays: some View {
        HStack {
            ForEach(currentWeek, id: \.self) { date in
                Text(date.displayDay(
                    longFormat: daySelected.isSameDay(as: date),
                    isToday: Date.now.isSameDay(as: date))
                )
                    .fontWeight(daySelected.isSameDay(as: date) ? .bold : .regular)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, daySelected.isSameDay(as: date) ? 7 : 0)
                    .background {
                        Capsule()
                            .fill(.thinMaterial)
                            .environment(\.colorScheme, .light)
                            .opacity(daySelected.isSameDay(as: date) ? 0.8 : 0)
                    }
                    .frame(width: daySelected.isSameDay(as: date) ? 140 : nil)
                    .onTapGesture {
                        withAnimation {
                            daySelected = date
                        }
                    }
            }
        }
    }
    private var minutesPicker: some View {
        Picker("Select value in minutes", selection: $minutesSelected) {
            ForEach(0..<301) {
                Text("\($0) min")
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
        
    }
}
