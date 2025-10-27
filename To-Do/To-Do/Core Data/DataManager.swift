//
//  DataManager.swift
//  To-Do
//
//  Created by HarshaHrudhay on 12/09/25.
//

import Foundation
import CoreData
import Combine


class DataManager: ObservableObject {               //  Obj
    static let shared = DataManager()
    let container: NSPersistentContainer

    var context: NSManagedObjectContext {
        container.viewContext
    }

    private init() {
        container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { desc, error in
            if let error = error {
                fatalError("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }

    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving: \(error.localizedDescription)")
            }
        }
    }
}
