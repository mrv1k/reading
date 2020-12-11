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
    func getAll(sortDescriptors: [NSSortDescriptor], predicate: NSPredicate?) -> Result<[Entity], RepositoryError>
    //    func update(id: UUID) -> Entity
    //    func delete(id: UUID) -> Entity
}

enum RepositoryError: Error {
    case requestFailed(with: Error)
    case typecast
    case idIsMissing
    case notFound
}

struct CoreDataRepository<Entity: NSManagedObject>: Repository {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func create() -> Entity {
        Entity(context: context)
    }

    typealias GetResult = Result<Entity, RepositoryError>
    func get(id: UUID?) -> GetResult {
        guard let id = id else { return .failure(.idIsMissing) }

        let request: NSFetchRequest = Entity.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %@", argumentArray: [id])

        let response = fetch(request)
            .flatMap { (response: [Entity]) -> GetResult in
                guard let found = response.first else { return .failure(.notFound) }
                return .success(found)
            }

        return response
    }

    func getAll(sortDescriptors: [NSSortDescriptor], predicate: NSPredicate? = nil) -> Result<[Entity], RepositoryError> {
        let request: NSFetchRequest = Entity.fetchRequest()
        request.sortDescriptors = sortDescriptors
        request.predicate = predicate

        let response = fetch(request)
        return response
    }

    typealias AbstractRequest = NSFetchRequest<NSFetchRequestResult>
    private func fetch(_ request: AbstractRequest) -> Result<[Entity], RepositoryError> {
        do {
            let rawResponse = try context.fetch(request)
            guard let response = rawResponse as? [Entity] else { return .failure(.typecast) }
            return .success(response)
        } catch {
            return .failure(.requestFailed(with: error))
        }
    }
}
