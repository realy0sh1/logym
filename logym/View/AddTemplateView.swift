//
//  AddTemplateView.swift
//  logym
//
//  Created by Tim Niklas Gruel on 25.07.24.
//

import SwiftUI
import SwiftData

struct AddTemplateView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Bindable var currentWorkout: Workout
    
    @State private var templateName: String = ""
    @State private var bodyPart: BodyPart = .full
    @State private var type: WorkoutType = .strength
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Name"){
                    HStack {
                        Image(systemName: "dumbbell.fill")
                            .foregroundStyle(Color("brightOrange"))
                        TextField("Add exercise name", text: $templateName)
                            .padding()
                    }
                }
            
                Section("Type") {
                    Picker("Select workout type", selection: $type) {
                        ForEach(WorkoutType.allCases, id: \.self) { type in
                            Text(String(describing: type))
                        }
                    }
                    #if !os(watchOS)
                    .pickerStyle(.segmented)
                    #endif
                }
                
                Section("Body part") {
                    VStack {
                        Picker("Select body part", selection: $bodyPart) {
                            ForEach(BodyPart.allCases, id: \.self) { part in
                                Text(String(describing: part))
                            }
                        }
                        #if !os(watchOS)
                        .pickerStyle(.wheel)
                        #endif
                        Button {
                            guard !templateName.isEmpty else { return }
                            withAnimation {
                                let template = ExerciseTemplate(name: templateName, bodyPart: bodyPart, type: type)
                                modelContext.insert(template)
                                
                                let exercise = Exercise()
                                currentWorkout.exercises?.append(exercise)
                                template.exercises?.append(exercise)
                                
                                templateName = ""
                            }
                            dismiss()
                        } label: {
                            Text("Create")
                                .foregroundStyle(Color("offWhite"))
                                #if os(watchOS)
                                .frame(width: 160, height: 60)
                                #else
                                .frame(width: 300, height: 60)
                                #endif
                                .background(Color("brightOrange"))
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                        .buttonStyle(.plain)
                        .disabled(templateName.isEmpty)
                    }
                }
            }
            .navigationTitle("New Template")
            .navigationBarTitleDisplayMode(.inline)
            #if !os(watchOS)
            .toolbar {
                ToolbarItem {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
            #endif
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Exercise.self, configurations: config)
        let workout = Workout()
        return AddTemplateView(currentWorkout: workout)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}
