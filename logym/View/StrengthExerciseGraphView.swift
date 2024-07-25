//
//  StrengthExerciseGraphView.swift
//  logym
//
//  Created by Tim Niklas Gruel on 25.07.24.
//

import Charts
import SwiftData
import SwiftUI

struct StrengthExerciseGraphView: View {
    @Bindable var exerciseTemplate: ExerciseTemplate
    
    var body: some View {
        VStack {
            if let exercises =  exerciseTemplate.exercises?.sorted(by: { $0.startDate < $1.startDate }) {
                Chart {
                    ForEach(exercises) { exercise in
                        LineMark(
                            x: .value("date", exercise.startDate),
                            y: .value("first set", exercise.sets.first?.weightOrTime ?? 0),
                            series: .value("data", "min")
                        )
                        .foregroundStyle(Color("superDarkGray"))
                    }
                    
                    ForEach(exercises) { exercise in
                        LineMark(
                            x: .value("date", exercise.startDate),
                            y: .value("last set", exercise.sets.last?.weightOrTime ?? 0),
                            series: .value("data", "max")
                        )
                        .foregroundStyle(Color("brightOrange"))
                    }
                }
            }
            
            HStack {
                HStack {
                    Image(systemName: "circle.fill")
                        .font(.caption2)
                        .rotationEffect(Angle(degrees: 45))
                        .foregroundStyle(Color("superDarkGray"))
                    
                    Text("first set in kg")
                        .foregroundColor(Color("offWhite"))
                }
                
                HStack {
                    Image(systemName: "circle.fill")
                        .font(.caption2)
                        .rotationEffect(Angle(degrees: 45))
                        .foregroundStyle(Color("brightOrange"))
                    
                    Text("last set in kg")
                        .foregroundColor(Color("offWhite"))
                }
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Workout.self, ExerciseTemplate.self, Exercise.self, configurations: config)
        let template = ExerciseTemplate()
        return StrengthExerciseGraphView(exerciseTemplate: template)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}
