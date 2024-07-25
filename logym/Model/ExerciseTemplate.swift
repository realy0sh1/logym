//
//  ExerciseTemplate.swift
//  logym
//
//  Created by Tim Niklas Gruel on 25.07.24.
//

import Foundation
import SwiftData

enum BodyPart: Codable, CaseIterable { case full, chest, back, arms, abs, legs, shoulders }
enum WorkoutType: Codable, CaseIterable { case strength, time }

@Model
class ExerciseTemplate: Identifiable {
    let id: UUID = UUID()
    var name: String = "Exercise Template"
    var bodyPart: BodyPart = BodyPart.full
    var type: WorkoutType = WorkoutType.strength
    
    @Relationship(deleteRule: .cascade, inverse: \Exercise.template) var exercises: [Exercise]?
    
    init(name: String = "Exercise Template", bodyPart: BodyPart = .full, type: WorkoutType = .strength) {
        self.name = name
        self.bodyPart = bodyPart
        self.type = type
        self.exercises = [Exercise]()
    }
}
