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
                ForEach(vm.activities) { activity in
                    NavigationLink {
                        DetailView(activity: activity)
                    } label: {
                        ActivityRow(activity: activity)
                    }
                    .listRowInsets(.init(top: 12, leading: 15, bottom: 12, trailing: 12))
                }
            }
            .navigationTitle("Activities")
            .toolbar {
                Button {
                    showAddActivity = true
                } label: {
                    Image(systemName: "plus")
                        .font(.title3.weight(.semibold))
                }
            }
            .fullScreenCover(isPresented: $showAddActivity) {
                AddActivityView(vm: vm)
            }
        }
    }
}

struct ActivitiesListView_Previews: PreviewProvider {
    static var previews: some View {
        ActivitiesListView()
    }
}
