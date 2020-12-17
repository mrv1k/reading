//
//  CDBookStorageTests.swift
//  readingTests
//
//  Created by Viktor Khotimchenko on 2020-12-15.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Combine
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
    var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        persistenceController = PersistenceController(inMemory: true)
        let viewContext = persistenceController.container.viewContext
        repository = DomainBookRepository(context: viewContext)

        // replace standard user defaults and reload restored sort
        userDefaults = UserDefaults(suiteName: #file)
        userDefaults.removePersistentDomain(forName: #file)
        CDBookSort.factory = CDBookSort.Factory(userDefaults: userDefaults)
        CDBookSort.restored = CDBookSort.factory.loadSort()

        cancellables = []
        storage = CDBookStorage(viewContext: viewContext)
    }

    func test_isEmptyWhenNoBooksAreStored() throws {
        XCTAssertTrue(storage.cdBooks.isEmpty)
    }

    func test_loadsAllStoredBooks() throws {
        let created = createAndSaveBooks()
        XCTAssert(storage.cdBooks.count == created.count, "Expected all persited books to be returned")
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

    // (ASC == <); (DESC == >)
    // xas - xctassert suggestion
    // FIXME: works but depends on title being default sort
//    func test_sortsByTitle() {
//        let initial = createAndSaveBooks()
//        let expected = initial.sorted { $0.title > $1.title }
//
//        let result = storage.cdBooks.map { $0.toDomainModel() }
//
//        zip(expected, result).forEach { expectedBook, resultBook in
//            XCTAssert(expectedBook == resultBook, "expected: \(expectedBook.title), found: \(resultBook.title)")
//        }
//    }

    func test_sortByAuthor() {
        // GIVEN
        let initial = createAndSaveBooks()
        let expected = initial.sorted { $0.author > $1.author }

        // WHEN
        storage.sortSelection = .author

        // THEN
        let controllerRefreshed = expectation(description: "expect controller to re-fetch books with new sort")
        storage.$cdBooks.dropFirst()
            .sink { cdBooks in
                let result = cdBooks.map { $0.toDomainModel() }

                zip(expected, result).forEach { expectedBook, resultBook in
                    XCTAssert(expectedBook == resultBook, "expected: \(expectedBook.title), found: \(resultBook.title)")
                }

                controllerRefreshed.fulfill()
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 1, handler: nil)
    }

//    func test_sortByTitle() {}
//    func test_sortByDate() {}
//    test_sortByDate() {}
//    test_sortByDate() {}
//    test_sortByDate() {}

    @discardableResult func createAndSaveBooks() -> [DomainBook] {
        let inputBooks = [DomainBook(title: "B", author: "Y", pageCount: 200),
                          DomainBook(title: "A", author: "Z", pageCount: 100),
                          DomainBook(title: "C", author: "X", pageCount: 300)]
        inputBooks.forEach { repository.create(domainBook: $0) }
        try! persistenceController.container.viewContext.save()
        return inputBooks
    }
}
