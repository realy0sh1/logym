//
//  ExerciseView.swift
//  logym
//
//  Created by Tim Niklas Gruel on 25.07.24.
//

import SwiftUI
import SwiftData

struct ExerciseView: View {
    
    @Bindable var exercise: Exercise
    
    var body: some View {
        if exercise.template?.type == .strength {
            StrengthExerciseView(exercise: exercise)
        } else {
            TimeExerciseView(exercise: exercise)
        }
        
        
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Exercise.self, configurations: config)
        let exercise = Exercise()
        exercise.sets.append(Set(weightOrTime: 15, reps: 15))
        exercise.sets.append(Set(weightOrTime: 20, reps: 15))
        return ExerciseView(exercise: exercise)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}

