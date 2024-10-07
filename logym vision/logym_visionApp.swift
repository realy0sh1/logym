//
//  logym_visionApp.swift
//  logym vision
//
//  Created by Tim Niklas Gruel on 07.10.24.
//

import SwiftUI

@main
struct logym_visionApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Workout.self, ExerciseTemplate.self, Exercise.self])
    }
}
