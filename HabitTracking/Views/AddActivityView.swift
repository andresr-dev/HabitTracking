//
//  AddActivityView.swift
//  HabitTracking
//
//  Created by Andres camilo Raigoza misas on 8/03/22.
//

import SwiftUI

struct AddActivityView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var vm: ActivitiesModel
    
    @State private var title = ""
    @State private var description = ""
    
    @State private var iconSelected = ActivityIcon.learn
    @State private var colorSelected = Color.primary
    
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Title here...", text: $title)
                    .font(.title3.weight(.semibold))
                    .padding(.vertical, 10)
                
                TextField("Description here...", text: $description)
                    .lineLimit(nil)
                    .padding(.vertical, 10)
                
                NavigationLink {
                    IconPickerView(iconSelected: $iconSelected, colorSelected: $colorSelected)
                } label: {
                    HStack {
                        Image(systemName: iconSelected.rawValue)
                            .foregroundColor(colorSelected)
                        Text("Icon")
                    }
                }
                .padding(.vertical, 10)
            }
            .navigationTitle("New Activity")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        addNewActivity()
                    }
                }
            }
            .alert(alertTitle, isPresented: $showAlert) {
                
            } message: {
                Text(alertMessage)
            }
        }
    }
    private func addNewActivity()  {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard trimmedTitle.count > 2 else {
            alertTitle = "Title too short!"
            alertMessage = "Title must be at least 3 characters long 😞"
            showAlert = true
            return
        }
        
        guard trimmedDescription.count > 4 else {
            alertTitle = "Description too short!"
            alertMessage = "Description must be at least 5 characters long 😔"
            showAlert = true
            return
        }
        
        let newActivity = Activity(title: trimmedTitle, description: trimmedDescription, iconName: iconSelected.rawValue, colorSelected: colorSelected)
        
        withAnimation {
            vm.activities.append(newActivity)
        }
        dismiss()
    }
}

struct AddActivityView_Previews: PreviewProvider {
    static var previews: some View {
        AddActivityView(vm: ActivitiesModel())
    }
}
