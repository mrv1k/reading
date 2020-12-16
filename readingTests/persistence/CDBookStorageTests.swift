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

/// Testing `CDBookStorage` and  it's supproting `CDBookSort` 
class CDBookStorageTests: XCTestCase {
    var cdBookStorage: CDBookStorage!
    // Supporting types
    var persistenceController: PersistenceController!
    var repository: DomainBookRepository!

    override func setUpWithError() throws {
        persistenceController = PersistenceController(inMemory: true)
        let viewContext = persistenceController.container.viewContext
        repository = DomainBookRepository(context: viewContext)
        cdBookStorage = CDBookStorage(viewContext: viewContext)
    }

    func test_isEmptyWhenNoBooksAreStored() throws {
        XCTAssertTrue(cdBookStorage.cdBooks.isEmpty)
    }

    func test_returnsAllStoredBooks() throws {
        let inputBooks = [DomainBook(title: "titleA", author: "authorA", pageCount: 100),
                          DomainBook(title: "titleB", author: "authorB", pageCount: 200),
                          DomainBook(title: "titleC", author: "authorC", pageCount: 300)]
        inputBooks.forEach { repository.create(domainBook: $0) }

        try! persistenceController.container.viewContext.save()

        XCTAssert(cdBookStorage.cdBooks.count == inputBooks.count, "Expected all persited books to be returned")
    }

    func test_loadsLastBookSort() {
        // given
        // when
        // then
    }

    func test_usesTitleSortWhenNoSavedSortIsFound() {
        // given
        // when
        // then
    }
}
