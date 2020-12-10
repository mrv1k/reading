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
    func create(domainBook: DomainBook) -> DomainBook
    func get(id: UUID?) -> DomainBook?
}

struct DomainBookRepository: DomainBookRepositoryInterface {
    private let repository: CoreDataRepository<Book>

    init(context: NSManagedObjectContext) {
        repository = CoreDataRepository(context: context)
    }

    func create(domainBook: DomainBook) -> DomainBook {
        let cdBook = repository.create()
        cdBook.title = domainBook.title
        cdBook.author = domainBook.author
        cdBook.pageCount = Int16(domainBook.pageCount)
        return cdBook.toDomainModel()
    }

    func get(id: UUID?) -> DomainBook? {
        let result = repository.get(id: id)
        switch result {
        case .success(let book):
            return book.toDomainModel()
        case .failure:
            // FIXME: handle errors
            fatalError("Unhandled core data repository failure")
        }
    }
}

protocol DomainModelConvertable {
    associatedtype DomainModel
    func toDomainModel() -> DomainModel
}

extension Book: DomainModelConvertable {
    func toDomainModel() -> DomainBook {
        DomainModel(
            title: title,
            author: author,
            pageCount: Int(pageCount),
            persistenceID: id
        )
    }
}
