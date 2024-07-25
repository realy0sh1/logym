//
//  StreakInfoView.swift
//  logym
//
//  Created by Tim Niklas Gruel on 25.07.24.
//

import SwiftUI
import SwiftData

struct StreakInfoView: View {
    @Environment(\.dismiss) var dismiss
    @Query private var workouts: [Workout]
    
    var body: some View {
        NavigationStack {
            List {
                Section() {
                    Text("The streak counts all workouts and resets after one inactive week.")
                        .foregroundStyle(Color("offWhite"))
                }
                
                Section("All workouts (\(workouts.count))") {
                    ForEach(workouts) { workout in
                        Text("Training from \(workout.startDate.formatted()) with \(workout.exercises?.count ?? 0) exercises")
                            .foregroundStyle(Color("offWhite"))
                    }
                }
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
            .navigationTitle("Streak")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    StreakInfoView()
}
