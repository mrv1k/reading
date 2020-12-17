//
//  CDBookStorageTests.swift
//  readingTests
//
//  Created by Viktor Khotimchenko on 2020-12-15.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import CoreData
@testable import reading
import XCTest

/// Testing `CDBookStorage` and  it's supproting `CDBookSort` Sorting elements
class CDBookStorageTests: XCTestCase {
    var storage: CDBookStorage!
    // Supporting types
    var persistenceController: PersistenceController!
    var repository: DomainBookRepository!

    override func setUpWithError() throws {
        persistenceController = PersistenceController(inMemory: true)
        let viewContext = persistenceController.container.viewContext
        repository = DomainBookRepository(context: viewContext)
        storage = CDBookStorage(viewContext: viewContext)
    }

    func test_isEmptyWhenNoBooksAreStored() throws {
        XCTAssertTrue(storage.cdBooks.isEmpty)
    }

    func test_loadsAllStoredBooks() throws {
        let inputBooks = [DomainBook(title: "titleA", author: "authorA", pageCount: 100),
                          DomainBook(title: "titleB", author: "authorB", pageCount: 200),
                          DomainBook(title: "titleC", author: "authorC", pageCount: 300)]
        inputBooks.forEach { repository.create(domainBook: $0) }
        try! persistenceController.container.viewContext.save()

        XCTAssert(storage.cdBooks.count == inputBooks.count, "Expected all persited books to be returned")
    }

    func test_loadsBooksInDefaultSortOrderWhenNoSavedSortIsFound() {
        let inputBooks = [DomainBook(title: "titleA", author: "authorA", pageCount: 100),
                          DomainBook(title: "titleB", author: "authorB", pageCount: 200),
                          DomainBook(title: "titleC", author: "authorC", pageCount: 300)]
        inputBooks.forEach { repository.create(domainBook: $0) }
        try! persistenceController.container.viewContext.save()

        // ascending == false
        // (ASC = <); (DESC >)
        let expectedBooks = inputBooks.sorted { $0.title > $1.title }

        let result = storage.cdBooks.map { $0.toDomainModel() }

        result.enumerated().forEach { index, foundBook in
            let expectedBook = expectedBooks[index]
            XCTAssert(foundBook == expectedBook, "expected: \(expectedBook.title), found: \(foundBook.title)")
        }
    }

    // change to author - sorts by author

    // change to author again - reverse author sort

    // change to createdAt

    // change back to author - restores reversed sort

    //    didSet { oldSortSelectionPublisher.send(oldValue) }

//    convertSelectionToSortChain
}
