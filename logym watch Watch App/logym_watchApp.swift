//
//  logym_watchApp.swift
//  logym watch Watch App
//
//  Created by Tim Niklas Gruel on 07.10.24.
//

import SwiftUI

@main
struct logym_watch_Watch_AppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Workout.self, ExerciseTemplate.self, Exercise.self])
    }
}
