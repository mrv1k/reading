//
//  DomainBookRepositoryTests.swift
//  readingTests
//
//  Created by Viktor Khotimchenko on 2020-12-09.
//  Copyright © 2020 mrv1k. All rights reserved.
//

@testable import reading
import XCTest
import CoreData

// persistenceController = PersistenceController.preview
// let persistenceController: PersistenceController
// let viewContext = persistenceController.container.viewContext

class LoginFormViewModel {}

class DomainBookRepositoryTests: XCTestCase {
    var persistenceController: PersistenceController!
    var viewContext: NSManagedObjectContext!
    var repository: DomainBookRepository!

    override func setUp() {
        persistenceController = PersistenceController(inMemory: true)
        viewContext = persistenceController.container.viewContext
        repository = DomainBookRepository(context: viewContext)
    }

    func test_createsABook() throws {
        let expected = DomainBook(title: "title", author: "author", pageCount: 100)

        let created = repository.create(domainBook: expected)
        XCTAssertTrue(created)

        let fetchRequest: NSFetchRequest = Book.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title = %@", expected.title)
        let response = try! viewContext.fetch(fetchRequest).first!

        let result = response.toDomainModel()
        XCTAssertTrue(result == expected, "Persisting domain model must save properties as is")
        XCTAssertNotNil(result.persistenceID, "Persiting domain model must write ID")
    }
}
