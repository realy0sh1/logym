//
//  logymVisionOSApp.swift
//  logymVisionOS
//
//  Created by Tim Niklas Gruel on 26.07.24.
//

import SwiftUI

@main
struct logymVisionOSApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Workout.self, ExerciseTemplate.self, Exercise.self])
    }
}
