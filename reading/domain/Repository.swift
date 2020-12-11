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
    func getAll(
        sortDescriptors: [NSSortDescriptor], matching predicate: NSPredicate?
    ) -> Result<[Entity], RepositoryError>
    //    func update(id: UUID) -> Entity
    //    func delete(id: UUID) -> Entity
}

enum RepositoryError: Error {
    case nilID
    case failedRequest(with: Error)
    case typecast
    case emptyResult
}

struct CoreDataRepository<Entity: NSManagedObject>: Repository {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func create() -> Entity {
        Entity(context: context)
    }

    func get(id: UUID?) -> Result<Entity, RepositoryError> {
        guard let id = id else { return .failure(.nilID) }

        let fetchRequest: NSFetchRequest = Entity.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id == %@", argumentArray: [id])

        do {
            if let response = try context.fetch(fetchRequest) as? [Entity] {
                guard let result = response.first else { return .failure(.emptyResult) }
                return .success(result)
            } else {
                return .failure(.typecast)
            }
        } catch {
            return .failure(.failedRequest(with: error))
        }
    }

    func getAll(
        sortDescriptors: [NSSortDescriptor],
        matching predicate: NSPredicate? = nil
    ) -> Result<[Entity], RepositoryError> {
        let fetchRequest: NSFetchRequest = Entity.fetchRequest()
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate

        // FIXME: copypasta
        do {
            if let response = try context.fetch(fetchRequest) as? [Entity] {
                return .success(response)
            } else {
                return .failure(.typecast)
            }

        } catch {
            return .failure(.failedRequest(with: error))
        }
    }
}
