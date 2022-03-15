//
//  setTodayValueView.swift
//  HabitTracking
//
//  Created by Andres camilo Raigoza misas on 13/03/22.
//

import SwiftUI

struct TimeSettingCard: View {
    let currentWeek: [Date]
    @Binding var minutesSelected: Int
    @Binding var showCard: Bool
    
    var body: some View {
        VStack {
            //headline
            weekdays
            Picker("Select value in minutes", selection: $minutesSelected) {
                ForEach(0..<301) {
                    Text("\($0) min")
                }
            }
            .pickerStyle(.wheel)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: UIScreen.main.bounds.height / 3 + 20)
        .background(.regularMaterial)
        .cornerRadius(30)
    }
}

struct TimeSettingCard_Previews: PreviewProvider {
    static var previews: some View {
        TimeSettingCard(currentWeek: Date().week, minutesSelected: .constant(0), showCard: .constant(false))
            .preferredColorScheme(.dark)
    }
}

extension TimeSettingCard {
    private var weekdays: some View {
        HStack {
            ForEach(currentWeek, id: \.self) {
                Text($0.displayDay)
                    //.fontWeight(.bold)
                    .frame(maxWidth: .infinity)
            }
        }
    }
    private var headline: some View {
        HStack {
            Text("OK")
            .font(.headline)
            .opacity(0)
            
            Spacer()
            
            Text("Today's value")
                .font(.title2.weight(.semibold))
            Spacer()
            
            Button {
                withAnimation(.easeInOut) {
                    showCard = false
                }
            } label: {
                Text("OK")
                    .font(.headline)
            }
        }
        .padding(.horizontal, 5)
    }
}
