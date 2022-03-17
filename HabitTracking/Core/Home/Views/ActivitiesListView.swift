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
    @State private var showDetailView = false
    @State private var indexSelected: Int?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.activities.indices, id: \.self) { index in
                    ActivityRow(activity: vm.activities[index])
                        .onTapGesture {
                            indexSelected = index
                            showDetailView = true
                        }
                        .listRowInsets(.init(top: 12, leading: 15, bottom: 12, trailing: 12))
                }
                .onDelete(perform: vm.delete)
                .onMove(perform: vm.move)
            }
            .navigationTitle("Habits")
            .background {
                NavigationLink(isActive: $showDetailView) {
                    DetailViewLoading(vm: vm, index: $indexSelected)
                } label: {
                    EmptyView()
                }
            }
            .onChange(of: showDetailView) { showDetail in
                if !showDetail {
                    indexSelected = nil
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                        .font(.headline)
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
            .preferredColorScheme(.dark)
    }
}

extension ActivitiesListView {
    private var addButton: some View {
        Button {
            showAddActivity = true
        } label: {
            Image(systemName: "plus")
                .font(.headline)
        }
    }
}
