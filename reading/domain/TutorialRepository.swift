//
//  TutorialRepository.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-12-07.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import CoreData
import Foundation

protocol TutorialRepository {
    associatedtype Entity

    func get(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> Result<[Entity], Error>

    func create() -> Result<Entity, Error>

    func delete(entity: Entity) -> Result<Bool, Error>
}

enum CoreDataError: Error {
    case invalidManagedObjectType
}

/// Now let's write a concrete implementation of how a generic Core Data repository:
class TutorialCoreDataRepository<T: NSManagedObject>: TutorialRepository {
    typealias Entity = T

    private let managedObjectContext: NSManagedObjectContext

    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }

    func get(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> Result<[Entity], Error> {
        let fetchRequest = Entity.fetchRequest()
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors

        do {
            if let fetchResults = try managedObjectContext.fetch(fetchRequest) as? [Entity] {
                return .success(fetchResults)
            }
            return .failure(CoreDataError.invalidManagedObjectType)
        } catch {
            return .failure(error)
        }
    }

    func create() -> Result<Entity, Error> {
        let className = String(describing: Entity.self)
        guard let managedObject = NSEntityDescription.insertNewObject(forEntityName: className, into: managedObjectContext) as? Entity else {
            return .failure(CoreDataError.invalidManagedObjectType)
        }
        return .success(managedObject)
    }

    func delete(entity: Entity) -> Result<Bool, Error> {
        managedObjectContext.delete(entity)
        return .success(true)
    }
}

/// He has `BookMo` for CoreData and `Book` for non core
/// I have   `Book`     for Core Data and `BookProxy` for non core
struct ProxyBook {
    var title: String
    var author: String
    var pageCount: Int
}

protocol DomainModel {
    associatedtype DomainModelType
    func toDomainModel() -> DomainModelType
}

extension Book: DomainModel {
    func toDomainModel() -> ProxyBook {
        ProxyBook(title: title, author: author, pageCount: Int(pageCount))
    }
}

/// Now let's build a concrete domain facing repository on top of our existing generic one that handles domain objects instead:
protocol BookRepositoryInterface {
    func getBooks(sortDescriptor: [NSSortDescriptor]?) -> Result<[ProxyBook], Error>

    func create(proxyBook: ProxyBook) -> Result<Bool, Error>
}

class ProxyBookRepository: ObservableObject, BookRepositoryInterface {
    private let repository: TutorialCoreDataRepository<Book>

    init(context: NSManagedObjectContext) {
        repository = TutorialCoreDataRepository<Book>(managedObjectContext: context)
    }

    func getBooks(sortDescriptor: [NSSortDescriptor]?) -> Result<[ProxyBook], Error> {
        let result = repository.get(predicate: nil, sortDescriptors: sortDescriptor)
        switch result {
        case .success(let books):
            let proxyBooks = books.map { book -> ProxyBook in
                book.toDomainModel()
            }
            return .success(proxyBooks)
        case .failure(let error):
            return .failure(error)
        }
    }

    func create(proxyBook: ProxyBook) -> Result<Bool, Error> {
        let result = repository.create()
        switch result {
        case .success(let book):
            book.title = proxyBook.title
            book.author = proxyBook.author
            book.pageCount = Int16(proxyBook.pageCount)
            return .success(true)
        case .failure(let error):
            return .failure(error)
        }
    }
}

class UnitOfWork {
    private let context: NSManagedObjectContext

    let proxyBookRepository: ProxyBookRepository

    init(context: NSManagedObjectContext) {
        self.context = context
        proxyBookRepository = ProxyBookRepository(context: context)
    }

    @discardableResult func saveChanges() -> Result<Bool, Error> {
        do {
            try context.save()
            return .success(true)
        } catch {
            context.rollback()
            return .failure(error)
        }
    }
}
