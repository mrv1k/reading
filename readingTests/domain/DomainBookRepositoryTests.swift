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
        let domain = DomainBook(title: "title", author: "author", pageCount: 100)

        let created = repository.create(domainBook: domain)
        XCTAssertTrue(created)

        let fetchRequest: NSFetchRequest = Book.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title = %@", domain.title)

        let fetched = try! viewContext.fetch(fetchRequest).first!
        XCTAssertTrue(fetched.title == domain.title, "Core data title must match domain title")
    }
}
