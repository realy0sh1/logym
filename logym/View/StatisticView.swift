//
//  StatisticView.swift
//  logym
//
//  Created by Tim Niklas Gruel on 25.07.24.
//

import Charts
import SwiftData
import SwiftUI


struct StatisticView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Workout.startDate, order: .reverse) private var workouts: [Workout]
    @Query(sort: \ExerciseTemplate.name, order: .forward) private var allExerciseTemplates: [ExerciseTemplate]
    
    @State private var showSteakInfo: Bool = false
    @State private var showDonate: Bool = false
    
    var streak: Int {
        // # workouts in a row with less than 1 week between
        var streak = 0
        var previousWorkout: Date = Date.now
        for workout in workouts {
            if workout.startDate.distance(to: previousWorkout) < 60*60*24*7 {
                streak += 1
                previousWorkout = workout.startDate
            } else {
                return streak
            }
        }
        return streak
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                #if !os(watchOS)
                Color("offWhite").ignoresSafeArea()
                #endif
                VStack {
                    #if !os(watchOS)
                    Button {
                        showSteakInfo = true
                    } label: {
                        Label("\(streak) workout streak", systemImage: "flame.fill")
                            .foregroundStyle(Color("offWhite"))
                            .frame(width: 300, height: 60)
                            .background(Color("babyBlue"))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    .buttonStyle(.plain)
                    .padding()
                    #endif
                    ExerciseTemplateListView(sort: SortDescriptor(\ExerciseTemplate.name), searchString: "")
                        //.searchable(text: $searchText)
                }
            }
            #if !os(watchOS)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button() {
                        showDonate = true
                    } label: {
                        Image(systemName: "giftcard")
                    }
                }
            }
            #endif
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showSteakInfo) {
            StreakInfoView()
        }
#if !os(watchOS)
        .sheet(isPresented: $showDonate) {
            DonateView()
        }
#endif
    }
    
    func deleteTemplate(_ indexSet: IndexSet) {
        for index in indexSet {
            let template =  allExerciseTemplates[index]
            modelContext.delete(template)
        }
    }
    
    /*
    func addSamples() {
        let workout1 = Workout(startDate: Date.now)
        let workout2 = Workout(startDate: Date(timeIntervalSinceNow: -60*60*24*6))
        let workout3 = Workout(startDate: Date(timeIntervalSinceNow: -60*60*24*11))
        let workout4 = Workout(startDate: Date(timeIntervalSinceNow: -60*60*24*19))
        let workout5 = Workout(startDate: Date(timeIntervalSinceNow: -60*60*24*30))
        let workout6 = Workout(startDate: Date(timeIntervalSinceNow: -60*60*24*31))
        
        modelContext.insert(workout1)
        modelContext.insert(workout2)
        modelContext.insert(workout3)
        modelContext.insert(workout4)
        modelContext.insert(workout5)
        modelContext.insert(workout6)
    }
    */
}


#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Workout.self, ExerciseTemplate.self, Exercise.self, configurations: config)
        
        return StatisticView()
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}

