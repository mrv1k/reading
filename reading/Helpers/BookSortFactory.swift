//
//  BookSortFactory.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-11-12.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import CoreData

enum BookSortSelection: String, CaseIterable, Identifiable {
    case title = "Title"
    case author = "Author"
    case createdAt = "Date"

    var id: String { rawValue }
}

struct BookSortFactory {
    private init() {}

    static func create(selection: BookSortSelection) -> BookSortProtocol {
        let sort: BookSortProtocol
        switch selection {
        case .author: sort = SortByAuthor()
        case .title: sort = SortByTitle()
        case .createdAt: sort = SortByCreatedAt()
        }
        // Sort creation means sort use. Safe to save
        sort.saveSort()
        return sort
    }
}

protocol BookSortProtocol {
    var directionImage: String { get }
    var ascendingKey: UserDefaultsKey { get }
    var ascending: Bool? { get set }
    var isAscending: Bool { get set }
    var selection: BookSortSelection { get }
    var descriptor: NSSortDescriptor { get }
}

extension BookSortProtocol {
    var directionImage: String { isAscending ? "chevron.up" : "chevron.down" }

    var isAscending: Bool {
        get { ascending == nil ? getSavedAscending() : ascending! }
        set { ascending = newValue
            // Setter fired means variable is in use. Safe to save
            saveAscending()
        }
    }

    fileprivate func saveSort() {
        UserDefaults.standard.set(selection.rawValue, forKey: UserDefaultsKey.bookSort.rawValue)
    }

    private func getSavedAscending() -> Bool {
        UserDefaults.standard.bool(forKey: ascendingKey.rawValue)
    }

    private func saveAscending() {
        UserDefaults.standard.set(ascending, forKey: ascendingKey.rawValue)
    }
}

extension BookSortFactory {
    struct SortByTitle: BookSortProtocol {
        var ascending: Bool?
        let ascendingKey = UserDefaultsKey.sortByTitle
        let selection = BookSortSelection.title
        var descriptor: NSSortDescriptor {
            NSSortDescriptor(
                key: #keyPath(Book.title),
                ascending: isAscending,
                selector: #selector(NSString.localizedStandardCompare(_:)))
        }
    }

    struct SortByAuthor: BookSortProtocol {
        var ascending: Bool?
        let ascendingKey = UserDefaultsKey.sortByAuthor
        let selection = BookSortSelection.author
        var descriptor: NSSortDescriptor {
            NSSortDescriptor(
                key: #keyPath(Book.author),
                ascending: isAscending,
                selector: #selector(NSString.localizedStandardCompare(_:)))
        }
    }

    struct SortByCreatedAt: BookSortProtocol {
        var ascending: Bool?
        let ascendingKey = UserDefaultsKey.sortByCreatedAt
        let selection = BookSortSelection.createdAt
        var descriptor: NSSortDescriptor {
            NSSortDescriptor(keyPath: \Book.createdAt, ascending: isAscending)
        }
    }
}

struct InitialBookSort {
    static let singleton = InitialBookSort()
    private init() {}

    var selection: BookSortSelection { loadSavedSort() ?? .title }
    var sort: BookSortProtocol { BookSortFactory.create(selection: selection) }

    private func loadSavedSort() -> BookSortSelection? {
        if let savedSort = UserDefaults.standard.string(forKey: UserDefaultsKey.bookSort.rawValue) {
            return BookSortSelection(rawValue: savedSort)
        }
        return nil
    }
}
