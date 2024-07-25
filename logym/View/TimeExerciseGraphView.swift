//
//  TimeExerciseGraphView.swift
//  logym
//
//  Created by Tim Niklas Gruel on 25.07.24.
//

import Charts
import SwiftData
import SwiftUI

struct TimeExerciseGraphView: View {
    @Bindable var exerciseTemplate: ExerciseTemplate
    
    var body: some View {
        VStack {
            if let exercises =  exerciseTemplate.exercises?.sorted(by: { $0.startDate < $1.startDate }) {
                Chart {
                    ForEach(exercises) { exercise in
                        LineMark(
                            x: .value("date", exercise.startDate),
                            y: .value("time", exercise.sets.last?.weightOrTime ?? 0),
                            series: .value("data", "max")
                        )
                        .foregroundStyle(Color("babyBlue"))
                    }
                }
            }
            
            HStack {
                HStack {
                    Image(systemName: "circle.fill")
                        .font(.caption2)
                        .rotationEffect(Angle(degrees: 45))
                        .foregroundStyle(Color("babyBlue"))
                    
                    Text("time in seconds")
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
        return TimeExerciseGraphView(exerciseTemplate: template)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}

