//
//  StreakInfoView.swift
//  logym
//
//  Created by Tim Niklas Gruel on 25.07.24.
//

import SwiftUI
import SwiftData

struct StreakInfoView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    @Query(sort: \Workout.startDate, order: .reverse) private var workouts: [Workout]
    @Query(sort: \ExerciseTemplate.name, order: .forward) private var templates: [ExerciseTemplate]
    
    var body: some View {
        NavigationStack {
            List {
                Section() {
                    Text("The streak counts all workouts and resets after one inactive week.")
                        .foregroundStyle(Color("offWhite"))
                }
                
                Section("All workouts (\(workouts.count))") {
                    ForEach(workouts) { workout in
                        Text("Training from \(workout.startDate.formatted()) with \(workout.exercises?.count ?? 0) exercises")
                            .foregroundStyle(Color("offWhite"))
                    }
                    .onDelete(perform: deleteWorkout)
                }
                
                Section("All templates (\(templates.count))") {
                    ForEach(templates) { template in
                        Text("Workout Template: \(template.name) (\(template.bodyPart))")
                    }
                    .onDelete(perform: deleteTemplate)
                }
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
            .navigationTitle("Streak")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func deleteTemplate(_ indexSet: IndexSet) {
        for index in indexSet {
            let template =  templates[index]
            modelContext.delete(template)
        }
    }

    func deleteWorkout(_ indexSet: IndexSet) {
        for index in indexSet {
            let workout =  workouts[index]
            modelContext.delete(workout)
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Workout.self, ExerciseTemplate.self, Exercise.self, configurations: config)
        return StreakInfoView()
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}
