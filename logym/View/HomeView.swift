//
//  HomeView.swift
//  logym
//
//  Created by Tim Niklas Gruel on 25.07.24.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(filter: #Predicate<Workout> {workout in workout.endDate == nil}, sort: \Workout.startDate) private var workouts: [Workout]
    
    @State private var path: [Workout] = []
    
    init() {
        #if !os(watchOS)
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(named: "almostBlack") as Any]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(named: "offWhite") as Any]
        #endif
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Color("offWhite").ignoresSafeArea()
                
                VStack {
                    Button {
                        // start new workout
                        addWorkout()
                    } label: {
                        Text("Start")
                            .foregroundStyle(Color("offWhite"))
                            #if os(watchOS)
                            .frame(width: 150, height: 60)
                            #else
                            .frame(width: 300, height: 60)
                            #endif
                            .background(Color("brightOrange"))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    .buttonStyle(.plain)
                    .disabled(workouts.count > 0)
                    .padding()
                    List {
                        Section("Resume workout") {
                            ForEach(workouts) { workout in
                                // we passing the data workout to the navigation link (needs to be Hashible)
                                NavigationLink(value: workout) {
                                    Text("Training from \(workout.startDate.formatted())")
                                    #if os(watchOS)
                                        .foregroundStyle(Color("almostBlack"))
                                    #else
                                        .foregroundStyle(Color("offWhite"))
                                    #endif
                                }
                                #if !os(watchOS)
                                .listRowBackground(Color("almostBlack"))
                                #endif
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color("superLightGray"))
                    .navigationTitle("Training")
                    
                    // here is the navigation destination: receive data of type Workout
                    .navigationDestination(for: Workout.self, destination: { workout in WorkoutView(workout: workout)})
                }
            }
            .preferredColorScheme(.dark)
        }
    }
    
    func addWorkout() {
        let workout = Workout()
        modelContext.insert(workout)
        path.append(workout)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Workout.self, ExerciseTemplate.self, Exercise.self, configurations: config)
        return HomeView()
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}
