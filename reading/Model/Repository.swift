//
//  Repository.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-12-07.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Foundation

protocol Repositry {
    associatedtype Entity

    func get(sortDescriptor: [NSSortDescriptor]?, predicate: NSPredicate?) -> Result<[Entity], Error>

    func create() -> Result<Entity, Error>

    func delete(entity: Entity) -> Result<Bool, Error>
}

enum CoreDataError: Error {
    case invalidManagedObjectType
}


