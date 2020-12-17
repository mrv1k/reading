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
    var userDefaults: UserDefaults!

    override func setUpWithError() throws {
        persistenceController = PersistenceController(inMemory: true)
        let viewContext = persistenceController.container.viewContext
        repository = DomainBookRepository(context: viewContext)

        // replace standard user defaults and reload restored sort
        userDefaults = UserDefaults(suiteName: #file)
        userDefaults.removePersistentDomain(forName: #file)
        CDBookSort.factory = CDBookSort.Factory(userDefaults: userDefaults)
        CDBookSort.restored = CDBookSort.factory.loadSort()

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

    /**
     Default ascending for all sorts is `false`
     Title `false` is Z to A - weird
     Author `false` is Z to A - weird
     Date `false` is newest first - good
     `Question`: Should I have different sort direction defaults?

     not implemented
     Page Count `false` is largest up top - debatable (10 to 1)
     Completion % `false` is completed up to - bad, users would have to scroll to get to currently reading books
     */
    func test_usesTitleAsDefaultSort() {
        XCTAssert(storage.sort.selection == .title)
        XCTAssert(storage.sort.isAscending == false)
    }

    // change to author again - reverse author sort

    // change to createdAt

    // change back to author - restores reversed sort
}
