//
//  CDBookSortTests.swift
//  readingTests
//
//  Created by Viktor Khotimchenko on 2020-12-16.
//  Copyright © 2020 mrv1k. All rights reserved.
//

@testable import reading
import XCTest

class CDBookSortTests: XCTestCase {
    var factory: CDBookSort.Factory!
    // helpers
    private var userDefaults: UserDefaults!

    override func setUpWithError() throws {
        userDefaults = UserDefaults(suiteName: #file)
        userDefaults.removePersistentDomain(forName: #file)
        factory = CDBookSort.Factory(userDefaults: userDefaults)
    }

    func test_createsSortFromSelection() {
        let result = factory.create(selection: .author)
        XCTAssert(result.selection == .author)
        XCTAssert(result.isAscending == false)
    }

    func test_createsReversedSortFromSelection() {
        let sortByAuthorAscending = factory.create(selection: .author, ascending: true)
        XCTAssert(sortByAuthorAscending.selection == .author)
        XCTAssert(sortByAuthorAscending.isAscending == true)

        let sortByAuthor = factory.create(selection: .author, ascending: false)
        XCTAssert(sortByAuthor.selection == .author)
        XCTAssert(sortByAuthor.isAscending == false)
    }

    func test_correctlyMapsSelectionToSort() {
        let selectedSortAuthor = factory.create(selection: .author)
        let selectedSortCreatedAt = factory.create(selection: .createdAt)
        let selectedSortTitle = factory.create(selection: .title)

        XCTAssert(selectedSortAuthor.selection == .author)
        XCTAssert(selectedSortCreatedAt.selection == .createdAt)
        XCTAssert(selectedSortTitle.selection == .title)
    }

    func test_savesSort() {
        let initiallySavedSort = factory.loadSort()
        let sortByAuthor = factory.create(selection: .author)

        let currentlySaved = factory.loadSort()

        XCTAssert(initiallySavedSort.selection != .author)
        XCTAssert(currentlySaved.selection == sortByAuthor.selection)
    }

    func test_loadsSort() {
        let sortByAuthor = factory.create(selection: .author)
        let result = factory.loadSort()
        XCTAssert(result.selection == sortByAuthor.selection)
    }

    func test_bugfix_loadedSortDoesNotGetSaved() {
        let initiallySavedSort = userDefaults.string(forKey: UserDefaultsKey.cdBookSort.rawValue)
        XCTAssertNil(initiallySavedSort)

        _ = factory.loadSort()

        let savedSort = userDefaults.string(forKey: UserDefaultsKey.cdBookSort.rawValue)
        XCTAssertNil(savedSort)
    }

    func test_defaultsToTitleSortWhenSavedSortIsNotFound() {
        let result = factory.loadSort()
        XCTAssert(result.selection == .title)
    }
}
