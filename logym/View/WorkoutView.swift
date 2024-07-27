//
//  WorkoutView.swift
//  logym
//
//  Created by Tim Niklas Gruel on 25.07.24.
//

import SwiftUI
import SwiftData

struct WorkoutView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @Bindable var workout: Workout
    
    // detect if workout is deleted (not great, but works:)
    @Query private var allWorkouts: [Workout]
    
    @Query private var templates: [ExerciseTemplate]
    
    @State private var selectedTemplate: ExerciseTemplate? = nil
    @State private var alertFinishWorkout: Bool = false
    @State private var sheetAddTemplate: Bool = false
    
    var body: some View {
            List {
                if !allWorkouts.contains(workout) {
                    Text("Workout deleted").onAppear { dismiss() }
                }
                
                Section("select template") {
                    HStack {
                        Picker("select template", selection: $selectedTemplate) {
                            Text("create new").tag(nil as ExerciseTemplate?)
                            ForEach(templates.filter { template in (workout.exercises?.contains(where: {$0.template == template}) ?? true) == false }) { template in
                                Text(template.name).tag(template as ExerciseTemplate?)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(height: 100)
                        
                        Button {
                            if selectedTemplate == nil {
                                // present sheet and create new template
                                sheetAddTemplate = true
                            } else {
                                addExercise()
                                selectedTemplate = nil
                            }
                            
                        } label: {
                            Image(systemName: "plus")
                                .font(.title)
                                .foregroundStyle(Color("superDarkGray"))
                                .frame(width: 60, height: 100)
                                .background( Color("offWhite"))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .listRowBackground(Color("brightOrange"))
                }
                
                ForEach(workout.exercises?.sorted { $0.startDate > $1.startDate } ?? []) { exercise in
                    Section() {
                            ExerciseView(exercise: exercise)
                                .swipeActions {
                                    Button(role: .destructive) {
                                        withAnimation {
                                            modelContext.delete(exercise)
                                        }
                                    } label: {
                                            Label("delete", systemImage: "trash.fill")
                                    }
                                }
                        }
                    .listRowBackground(Color("offWhite"))
                }
            }
            .preferredColorScheme(.dark)
            .scrollContentBackground(.hidden)
            .background(Color("almostBlack"))
            .navigationTitle("Workout")
            .toolbar {
                ToolbarItem {
                    Button() {
                        alertFinishWorkout = true
                    }label: {
                        Text("Finish")
                    }
                    .disabled((workout.exercises?.count ?? 0) < 1)
                
                        
                }
            }
            .alert("Are you sure that you want to finish the workout?", isPresented: $alertFinishWorkout) {
                Button("Cancel", role: .cancel) {}
                Button("Finish", role: .destructive) {
                    workout.endDate = .now
                    dismiss()
                }
            }
            .sheet(isPresented: $sheetAddTemplate) {
                AddTemplateView(currentWorkout: workout)
            }
            .navigationBarTitleDisplayMode(.inline)
    }
    
    
    func addExercise() {
        guard selectedTemplate != nil else { return }
        
        withAnimation {
            let exercise = Exercise()
            workout.exercises?.append(exercise)
            selectedTemplate?.exercises?.append(exercise)
        }
    }
    
    func deleteExercise(_ indexSet: IndexSet) {
        for index in indexSet {
            if let exercise =  workout.exercises?[index] {
                modelContext.delete(exercise)
            }
            
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Workout.self, configurations: config)
        let workout = Workout()
        return WorkoutView(workout: workout)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}

