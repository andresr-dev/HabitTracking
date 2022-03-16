//
//  ContentView.swift
//  HabitTracking
//
//  Created by Andres camilo Raigoza misas on 8/03/22.
//

import SwiftUI

struct ActivitiesListView: View {
    @StateObject var vm = ActivitiesModel()
    @State private var showAddActivity = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.activities.indices, id: \.self) { index in
                    NavigationLink {
                        DetailView(vm: vm, index: index)
                    } label: {
                        ActivityRow(activity: vm.activities[index])
                    }
                    .listRowInsets(.init(top: 12, leading: 15, bottom: 12, trailing: 12))
                }
                .onDelete(perform: vm.delete)
                .onMove(perform: vm.move)
            }
            .navigationTitle("Activities")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    addButton
                }
            }
            .sheet(isPresented: $showAddActivity) {
                AddActivityView(vm: vm)
                    .interactiveDismissDisabled(true)
            }
        }
    }
}

struct ActivitiesListView_Previews: PreviewProvider {
    static var previews: some View {
        ActivitiesListView()
    }
}

extension ActivitiesListView {
    private var addButton: some View {
        Button {
            showAddActivity = true
        } label: {
            Image(systemName: "plus")
                .font(.title3)
        }
    }
}
