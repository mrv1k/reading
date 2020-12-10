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
    func get(id: UUID?) -> Result<Entity, RepositoryError>
//    func update(id: UUID) -> Entity
//    func delete(id: UUID) -> Entity
//    func getAll(sortDescriptors: [NSSortDescriptor], predicate: NSPredicate?) -> [Entity]
}

enum RepositoryError: Error {
    case idIsNil
    case fetchFailed(with: Error)
    case emptyResult
}

class CoreDataRepository<CDEntity: NSManagedObject>: Repository {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func create() -> CDEntity {
        CDEntity(context: context)
    }

    func get(id: UUID?) -> Result<CDEntity, RepositoryError> {
        guard let id = id else { return .failure(.idIsNil) }

        let fetchRequest: NSFetchRequest = CDEntity.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id == %@", argumentArray: [id])

        do {
            let response = try context.fetch(fetchRequest) as! [CDEntity]
            guard let result = response.first else { return .failure(.emptyResult) }
            return .success(result)
        } catch {
            return .failure(.fetchFailed(with: error))
        }
    }
}
