//
//  Workout.swift
//  logym
//
//  Created by Tim Niklas Gruel on 25.07.24.
//

import Foundation
import SwiftData

@Model
class Workout: Identifiable, Hashable {
    var id: UUID = UUID()
    // for CloudKit each var needs to have a default value or be an optional
    var startDate: Date = Date.now
    var endDate: Date?
    // if I remove a object from the exercise array, delete the object (and not only the reference)
    // for CloudKit each relationship must be optional :(
    @Relationship(deleteRule: .cascade, inverse: \Exercise.workout) var exercises: [Exercise]?
    
    init(startDate: Date = .now) {
        self.startDate = startDate
        self.endDate = nil
        self.exercises = [Exercise]()
    }
}
