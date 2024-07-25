//
//  ExerciseTemplateListView.swift
//  logym
//
//  Created by Tim Niklas Gruel on 25.07.24.
//

import Charts
import SwiftData
import SwiftUI

struct ExerciseTemplateListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ExerciseTemplate.name, order: .forward) private var allExerciseTemplates: [ExerciseTemplate]
    
    
    init(sort: SortDescriptor<ExerciseTemplate>, searchString: String = "") {
        // we want to change the query itself (and not only the data that it returns), so we need to do this:
        _allExerciseTemplates = Query(filter: #Predicate {
            if searchString.isEmpty {
                return true
            } else {
                return $0.name.localizedStandardContains(searchString)
            }
        }, sort: [sort])
    }

    var body: some View {
        List {
            ForEach(allExerciseTemplates) { exerciseTemplate in
                Section("\(exerciseTemplate.name) (\(exerciseTemplate.bodyPart))") {
                    if exerciseTemplate.type == .strength {
                        StrengthExerciseGraphView(exerciseTemplate: exerciseTemplate)
                    } else {
                        TimeExerciseGraphView(exerciseTemplate: exerciseTemplate)
                    }
                }
            }
            .onDelete(perform: deleteTemplate)
            .listRowBackground(Color("almostBlack"))
        }
        .scrollContentBackground(.hidden)
        .background(Color("superLightGray"))
        .navigationTitle("Statistics")
    }
    
    func deleteTemplate(_ indexSet: IndexSet) {
        for index in indexSet {
            let template =  allExerciseTemplates[index]
            modelContext.delete(template)
        }
    }
}


#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Workout.self, ExerciseTemplate.self, Exercise.self, configurations: config)
        
        return ExerciseTemplateListView(sort: SortDescriptor(\ExerciseTemplate.name))
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}
