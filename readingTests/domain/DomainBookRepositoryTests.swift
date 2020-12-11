//
//  DomainBookRepositoryTests.swift
//  readingTests
//
//  Created by Viktor Khotimchenko on 2020-12-09.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import CoreData
@testable import reading
import XCTest

class DomainBookRepositoryTests: XCTestCase {
    var persistenceController: PersistenceController!
    var viewContext: NSManagedObjectContext!
    var repository: DomainBookRepository!

    override func setUp() {
        persistenceController = PersistenceController(inMemory: true)
        viewContext = persistenceController.container.viewContext
        repository = DomainBookRepository(context: viewContext)
    }

    func test_shouldCreateABook() throws {
        let expected = DomainBook(title: "title", author: "author", pageCount: 100)
        let result = repository.create(domainBook: expected)

        XCTAssertTrue(result == expected, "Saves properties without mutations")
        XCTAssertNotNil(result.persistenceID, "Set `persistenceID` as indicator of getting persisted")
    }

    func test_shouldGetABook() {
        let input = DomainBook(title: "title", author: "author", pageCount: 100)
        let created = repository.create(domainBook: input)

        let result = repository.get(id: created.persistenceID)
        XCTAssertNotNil(result)
        XCTAssertNoThrow(result, "Expected to handle errors")
    }

    func test_shouldGetAllBooks() {
        let inputBooks = [DomainBook(title: "titleA", author: "authorA", pageCount: 100),
                          DomainBook(title: "titleB", author: "authorB", pageCount: 200),
                          DomainBook(title: "titleC", author: "authorC", pageCount: 300)]

        inputBooks.forEach { repository.create(domainBook: $0) }

        let result = repository.getAll()

        XCTAssertEqual(result.count, inputBooks.count, "Returns all persisted books")
    }
}
