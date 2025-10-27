//
//  Entity+CoreDataProperties.swift
//  To-Do
//
//  Created by HarshaHrudhay on 12/09/25.
//
//

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var descriptionn: String?
    @NSManaged public var selectedCategory: String?
    @NSManaged public var reminderDate: Date?
    @NSManaged public var taskDate: Date?
    @NSManaged public var isCompleted: Bool

}

extension Entity : Identifiable {

}

