//
//  NoteViewModel.swift
//  To-Do
//
//  Created by HarshaHrudhay on 12/09/25.
//

import Foundation
import SwiftUI
import CoreData
import Combine

class NoteViewModel: ObservableObject, Identifiable {
    
    var id: UUID
    
    @Published var title: String
    @Published var description: String
    @Published var selectedCategory: Category? = nil
    @Published var reminderDate: Date
    @Published var taskDate: Date = Date()
    @Published var isCompleted: Bool = false
    
    enum Category: String, CaseIterable, Identifiable {
        case study = "graduationcap.fill"
        case health = "heart.fill"
        case home = "house.fill"
        case work = "calendar"
        case personal = "person.fill"
        
        var id: String { self.rawValue }
        
        var color: Color {
            switch self {
            case .study: return .blue
            case .health: return .orange
            case .home: return .green
            case .work: return .purple
            case .personal: return .cyan
            }
        }
    }
    
    init(id: UUID, title: String, description: String, reminderDate: Date = Date(), taskDate: Date = Date(), isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.description = description
        self.reminderDate = reminderDate
        self.taskDate = taskDate
        self.isCompleted = isCompleted
    }
}


class NotesStore: ObservableObject {
    
    @Published var notes: [NoteViewModel] = []
    private let context = DataManager.shared.context
    
    init () {
        fetchNotes()
    }
    
    
    func fetchNotes() {
        let request: NSFetchRequest<Entity> = Entity.fetchRequest()
        do {
            let entities = try context.fetch(request)
            self.notes = entities.compactMap { entity in
                guard let id = entity.id else { return nil }
                let note = NoteViewModel(
                    id: id,
                    title: entity.title ?? "",
                    description: entity.descriptionn ?? "",
                    reminderDate: entity.reminderDate ?? Date(),
                    isCompleted: entity.isCompleted
                )
                if let catRaw = entity.selectedCategory {
                    note.selectedCategory = NoteViewModel.Category(rawValue: catRaw)
                }
                note.taskDate = entity.taskDate ?? Date()
                return note
            }
        } catch {
            print("Fetch failed: \(error.localizedDescription)")
        }
    }
    
    
    func add(note: NoteViewModel) {
        let entity = Entity(context: context)
        entity.id = note.id
        entity.title = note.title
        entity.descriptionn = note.description
        entity.taskDate = note.taskDate
        entity.reminderDate = note.reminderDate
        entity.selectedCategory = note.selectedCategory?.rawValue
        entity.isCompleted = note.isCompleted
        
        DataManager.shared.save()
        fetchNotes()
    }
    
    func delete(note: NoteViewModel) {
        let request: NSFetchRequest<Entity> = Entity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", note.id as CVarArg)
        
        do {
            if let entity = try context.fetch(request).first {
                context.delete(entity)
                DataManager.shared.save()
                fetchNotes()
            }
        } catch {
            print("Delete failed: \(error.localizedDescription)")
        }
    }
    
    
    func update(note: NoteViewModel) {
        let request: NSFetchRequest<Entity> = Entity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", note.id as CVarArg)

        do {
            if let entity = try context.fetch(request).first {
                entity.title = note.title
                entity.descriptionn = note.description
                entity.taskDate = note.taskDate
                entity.reminderDate = note.reminderDate
                entity.selectedCategory = note.selectedCategory?.rawValue
                entity.isCompleted = note.isCompleted
                
                DataManager.shared.save()
                fetchNotes()
            }
        } catch {
            print("Update failed: \(error.localizedDescription)")
        }
    }

    
    
    func toggleCompletion(for note: NoteViewModel) {
        let request: NSFetchRequest<Entity> = Entity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", note.id as CVarArg)
        
        do {
            if let entity = try context.fetch(request).first {
                entity.isCompleted.toggle()
                DataManager.shared.save()
                fetchNotes()
            }
        } catch {
            print("Toggle failed: \(error.localizedDescription)")
        }
    }
}



