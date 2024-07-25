//
//  TimeExerciseView.swift
//  logym
//
//  Created by Tim Niklas Gruel on 25.07.24.
//

import SwiftUI
import SwiftData

struct TimeExerciseView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Bindable var exercise: Exercise
    
    @State private var time: Double = 0
    
    // load last sothat we can make prediction for this one
    @State var lastSet: [Set] = []
    
    let numberOfSets: Int = 1
    
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
            HStack {
                Image(systemName: allSetsDone ? "checkmark.circle" : "\(setsLeft).circle")
                    .font(.largeTitle)
                    .foregroundStyle(allSetsDone ? Color("babyBlue") : Color("superDarkGray"))
                    .symbolEffect(.bounce, value: allSetsDone)
                Text(exercise.template?.name ?? "Unknown template")
                    .foregroundStyle(Color("superDarkGray"))
                Spacer()
                VStack(alignment: .trailing) {
                    HStack {
                        Text("\(String(format: "%.0f", time)) seconds")
                            .fixedSize()
                            .foregroundStyle(Color("superDarkGray"))
                        Stepper("", value: $time, in: 0...300, step: 10.0)
                            .labelsHidden()
                    }
                }
            }
            
            Divider()
            
            HStack {
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(exercise.sets) { set in
                            VStack {
                                Text("\(set.weightOrTime.formatted()) s")
                                    .foregroundStyle(Color("offWhite"))
                            }
                            .onTapGesture(perform: {
                                withAnimation {
                                    exercise.sets.removeAll(where: {$0.id == set.id})
                                    // load values from last set
                                    if exercise.sets.count < lastSet.count {
                                        time = lastSet[exercise.sets.count].weightOrTime
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
                    exercise.sets.append(Set(weightOrTime: time, reps: 1))
                    // load values from last set
                    if exercise.sets.count < lastSet.count {
                        time = lastSet[exercise.sets.count].weightOrTime
                    }
                } label: {
                    Image(systemName: "plus")
                        .font(.title)
                        .foregroundStyle(allSetsDone ? Color("superDarkGray") : Color("offWhite"))
                        .frame(width: 60, height: 60)
                        .background(allSetsDone ? Color("superLightGray") : Color("babyBlue"))
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
                time = lastSet[exercise.sets.count].weightOrTime
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
        return ExerciseView(exercise: exercise)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}
