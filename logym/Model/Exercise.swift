//
//  Exercise.swift
//  logym
//
//  Created by Tim Niklas Gruel on 25.07.24.
//

import Foundation
import SwiftData


struct Set: Codable, Identifiable {
    var id: UUID = UUID()
    // data: could be kg or seconds of exercise
    var weightOrTime: Double
    var reps: Int
}

@Model
class Exercise: Identifiable {
    let id: UUID = UUID()
    var startDate: Date = Date.now
    var sets: [Set] = []
    
    
    var workout: Workout?
    var template: ExerciseTemplate?
    
    init() {
        self.startDate = .now
        self.sets = []
    }
}
