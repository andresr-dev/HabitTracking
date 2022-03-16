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
    @State private var goal: Int?
    
    @State private var iconSelected = ActivityIcon.learn
    @State private var colorSelected = Color.primary
    
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                titleField
                descriptionField
                iconSelection
                goalField
            }
            .navigationTitle("New Activity")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done", action: addNewActivity)
                }
            }
            .alert(alertTitle, isPresented: $showAlert) {
            } message: { Text(alertMessage) }
        }
    }
}

struct AddActivityView_Previews: PreviewProvider {
    static var previews: some View {
        AddActivityView(vm: ActivitiesModel())
            .preferredColorScheme(.dark)
    }
}

// MARK: - VIEWS
extension AddActivityView {
    private var titleField: some View {
        TextField("Title...", text: $title)
            .font(.title3.weight(.semibold))
            .padding(.vertical, 10)
    }
    private var descriptionField: some View {
        TextField("Description...", text: $description)
            .padding(.vertical, 10)
    }
    private var iconSelection: some View {
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
    private var goalField: some View {
        HStack {
            Text("Daily Goal:")
            Spacer()
            TextField("##", value: $goal, format: .number)
                .keyboardType(.numberPad)
                .padding(4)
                .multilineTextAlignment(.center)
                .frame(width: 48)
                .background(Color(uiColor: .tertiarySystemBackground))
                .cornerRadius(5)
            Text("min")
        }
        .padding(.vertical, 7)
    }
}


// MARK: - FUNCTIONS
extension AddActivityView {
    
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
        guard let goal = goal else {
            alertTitle = "Goal is empty!"
            alertMessage = "You must assign a daily goal in minutes 🙁"
            showAlert = true
            return
        }
        guard goal > 0 else {
            alertTitle = "Invalid Goal!"
            alertMessage = "Goal must be greater than 0 🙁"
            showAlert = true
            return
        }
        vm.addNewActivity(
            title: trimmedTitle,
            description: trimmedDescription,
            iconName: iconSelected.rawValue,
            colorSelected: colorSelected.cgColor?.components,
            goal: goal
        )
        dismiss()
    }
}
