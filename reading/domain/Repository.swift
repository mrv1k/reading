//
//  Repository.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-12-09.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import CoreData
import Foundation

protocol Repository {
    associatedtype Entity

    func create() -> Entity
//    func get(id: UUID) -> Entity
//    func update(id: UUID) -> Entity
//    func delete(id: UUID) -> Entity
//    func getAll(sortDescriptors: [NSSortDescriptor], predicate: NSPredicate?) -> [Entity]
}

class CoreDataRepository<CDEntity: NSManagedObject>: Repository {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func create() -> CDEntity {
        CDEntity(context: context)
    }
}

