//
//  ContentView.swift
//  logym
//
//  Created by Tim Niklas Gruel on 25.07.24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selectedTab = "current"
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Training", systemImage: "list.clipboard")
                }
                .tag("current")
            
            StatisticView()
                .tabItem {
                    Label("Statistics", systemImage: "chart.xyaxis.line")
                }
                .tag("statistics")
            /*
            ManagementView()
                .tabItem { Text("admin") }
                .tag("admin")
            */
        }
        .accentColor(Color("brightOrange"))
        
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Workout.self, ExerciseTemplate.self, Exercise.self, configurations: config)
        return ContentView()
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}

