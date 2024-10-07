//
//  StrengthExerciseView.swift
//  logym
//
//  Created by Tim Niklas Gruel on 25.07.24.
//

import SwiftUI
import SwiftData

struct StrengthExerciseView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Bindable var exercise: Exercise
    
    @State private var weight: Double = 0
    @State private var repetitions: Int = 15
    
    // load last sothat we can make prediction for this one
    @State var lastSet: [Set] = []
    
    let numberOfSets: Int = 4
    
    var allSetsDone: Bool {
        // todo make 4 configurable
        exercise.sets.count >= numberOfSets
    }
    
    var setsLeft: Int {
        let left = numberOfSets - exercise.sets.count
        // we only have the icon from 0 upto 50
        switch left {
            case _ where left >= 50:
                return 50
            case _ where left <= 0:
                return 0
            default:
                return left
        }
    }
    

    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Image(systemName: allSetsDone ? "checkmark.circle" : "\(setsLeft).circle")
                        .font(.largeTitle)
                        .foregroundStyle(allSetsDone ? Color("brightOrange") : Color("superDarkGray"))
                        .symbolEffect(.bounce, value: allSetsDone)
                    
                    Spacer()
                }
                HStack {
                    Spacer()
                    VStack(alignment: .trailing) {
                        HStack {
                            Text("\(repetitions.formatted()) x")
                                .fixedSize()
                                .foregroundStyle(Color("superDarkGray"))
                            Stepper("", value: $repetitions, in: 1...50, step: 1)
                                .labelsHidden()
                                #if os(watchOS)
                                    .frame(width: 70)
                                #endif
                        }
                        HStack {
                            Text(String(format: "%.1f %@", weight, Locale.current.measurementSystem == .metric ? "kg" : "lb" ))
                                .fixedSize()
                                .foregroundStyle(Color("superDarkGray"))
                            Stepper("", value: $weight, in: 0...999, step: 0.5)
                                .labelsHidden()
                                #if os(watchOS)
                                    .frame(width: 70)
                                #endif
                        }
                    }
                }
            }
            
            
            Divider()
            
            HStack {
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(exercise.sets) { set in
                            VStack {
                                Text("\(set.reps)x")
                                    .foregroundStyle(Color("offWhite"))
                                Text(String(format: "%.0f %@", set.weightOrTime, Locale.current.measurementSystem == .metric ? "kg" : "lb" ))
                                    .foregroundStyle(Color("offWhite"))
                            }
                            .onLongPressGesture(perform: {
                                withAnimation {
                                    exercise.sets.removeAll(where: {$0.id == set.id})
                                    // load values from last set
                                    if exercise.sets.count < lastSet.count {
                                        repetitions = lastSet[exercise.sets.count].reps
                                        weight = lastSet[exercise.sets.count].weightOrTime
                                    }
                                    
                                }
                            })
                            .frame(width: 70, height: 70)
                            .background(Color("superDarkGray"))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    
                }
                
                
                Button {
                    exercise.sets.append(Set(weightOrTime: weight, reps: repetitions))
                    // load values from last set
                    if exercise.sets.count < lastSet.count {
                        repetitions = lastSet[exercise.sets.count].reps
                        weight = lastSet[exercise.sets.count].weightOrTime
                    }
                } label: {
                    Image(systemName: "plus")
                        .font(.title)
                        .foregroundStyle(allSetsDone ? Color("superDarkGray") : Color("offWhite"))
                        .frame(width: 60, height: 60)
                        .background(allSetsDone ? Color("superLightGray") : Color("brightOrange"))
                        .clipShape(Circle())
                }
                .buttonStyle(PlainButtonStyle())
                .frame(height: 70)
            }
        }
        .onAppear { loadLastSet() }
    }
    
    func loadLastSet() {
        let descriptor = FetchDescriptor<Exercise>()
        do {
            let exercises = try modelContext.fetch(descriptor)
            let pastExercises = exercises.filter({ $0.template == exercise.template && $0.workout != exercise.workout}).sorted(by: { $0.startDate < $1.startDate })
            if let lastExercise = pastExercises.last {

               lastSet = lastExercise.sets
            }
            if exercise.sets.count < lastSet.count {
                repetitions = lastSet[exercise.sets.count].reps
                weight = lastSet[exercise.sets.count].weightOrTime
            }
        } catch {
           print("fetching failed")
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
        return StrengthExerciseView(exercise: exercise)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}
