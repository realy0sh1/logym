//
//  ManagementView.swift
//  logym
//
//  Created by Tim Niklas Gruel on 25.07.24.
//

import SwiftUI
import SwiftData

struct ManagementView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var templates: [ExerciseTemplate]
    @Query private var workouts: [Workout]
    @Query private var exercises: [Exercise]
    
    @State private var templateName: String = ""
    @State private var bodyPart: BodyPart = .full
    
    @State private var selectedTemplate: ExerciseTemplate? = nil
    
    @State private var path = [Workout]()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Text("total # workouts: \(workouts.count)")
                Text("total # exercises: \(exercises.count)")
                Text("total # temlpates: \(templates.count)")
                
                List {
                    Section("Templates") {
                        ForEach(templates) { template in
                            Text("Workout Template: \(template.name) (\(template.bodyPart))")
                        }
                        .onDelete(perform: deleteTemplate)
                    }
                    
                    Section("Workouts") {
                        ForEach(workouts) { workout in

                            NavigationLink {
                                WorkoutView(workout: workout)
                            } label: {
                                Text("workout")
                            }
                        }
                        .onDelete(perform: deleteWorkout)
                    }
                }
            }
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
        return ManagementView()
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}
