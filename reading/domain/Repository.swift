//
//  Repository.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-12-09.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Foundation

protocol Repository {
    associatedtype Entity

    func getAll(sortDescriptors: [NSSortDescriptor]) -> [Entity]
    //    func getSubscript(sortDescriptors: [NSSortDescriptor], predicate: NSPredicate) -> [Entity]
    func create() -> Entity
    func get(id: UUID) -> Entity
    // func update(id: UUID) -> Entity
    func delete(id: UUID) -> Entity
}
