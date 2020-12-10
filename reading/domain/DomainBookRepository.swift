//
//  DomainBookRepository.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-12-09.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import CoreData
import Foundation

protocol DomainBookRepositoryInterface {
    func create(domainBook: DomainBook) -> Bool
}

struct DomainBookRepository: DomainBookRepositoryInterface {
    private let repository: CoreDataRepository<Book>

    init(context: NSManagedObjectContext) {
        repository = CoreDataRepository(context: context)
    }

    func create(domainBook: DomainBook) -> Bool {
        let cdBook = repository.create()
        cdBook.title = domainBook.title
        cdBook.author = domainBook.author
        cdBook.pageCount = Int16(domainBook.pageCount)
        return true
    }
}

protocol DomainModelConvertable {
    associatedtype DomainModel
    func toDomainModel() -> DomainModel
}

extension Book: DomainModelConvertable {
    func toDomainModel() -> DomainBook {
        DomainModel(
            id: id,
            title: title,
            author: author,
            pageCount: Int(pageCount))
    }
}
