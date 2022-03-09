//
//  IconPickerView.swift
//  HabitTracking
//
//  Created by Andres camilo Raigoza misas on 8/03/22.
//

import SwiftUI

struct IconPickerView: View {
    let columns = [GridItem(.adaptive(minimum: 100), spacing: 10)]
    
    @State private var allIcons = ActivityIcon.allCases
    @Binding var iconSelected: ActivityIcon
    @Binding var colorSelected: Color
    
    var body: some View {
        VStack(spacing: 30) {
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .stroke(.primary, lineWidth: 1)
                
                Image(systemName: iconSelected.rawValue)
                    .font(.system(size: 85, weight: .light, design: .default))
                    .foregroundColor(colorSelected)
                    
            }
            .frame(width: 180, height: 180)
            
            ColorPicker("Select Color:", selection: $colorSelected)
                .font(.headline)
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.bottom, 8)
            
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(allIcons, id: \.rawValue) { icon in
                    Image(systemName: icon.rawValue)
                        .font(.system(size: 50, weight: .light, design: .default))
                        .onTapGesture {
                          iconSelected = icon
                        }
                }
            }
            .padding(.horizontal, 15)
        }
        .navigationTitle("Icon Selection")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct IconPickerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            IconPickerView(iconSelected: .constant(.brain), colorSelected: .constant(.black))
        }
    }
}
