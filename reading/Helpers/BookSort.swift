//
//  BookSort.swift
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

    static func create(selection: BookSortSelection) -> BookSort {
        let sort: BookSort
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

protocol BookSort {
    var directionImage: String { get }
    var ascendingKey: UserDefaultsKey { get }
    var ascending: Bool? { get set }
    var isAscending: Bool { get set }
    var selection: BookSortSelection { get }
    var descriptor: NSSortDescriptor { get }
}

extension BookSort {
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
    struct SortByTitle: BookSort {
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

    struct SortByAuthor: BookSort {
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

    struct SortByCreatedAt: BookSort {
        var ascending: Bool?
        let ascendingKey = UserDefaultsKey.sortByCreatedAt
        let selection = BookSortSelection.createdAt
        var descriptor: NSSortDescriptor {
            NSSortDescriptor(keyPath: \Book.createdAt, ascending: isAscending)
        }
    }
}

struct InitialBookSort {
    static var sort: BookSort {
        let selection: BookSortSelection

        // Try to load saved sort
        if let savedSort = UserDefaults.standard.string(forKey: UserDefaultsKey.bookSort.rawValue) {
            selection = BookSortSelection(rawValue: savedSort)!
        } else {
            selection = .title
        }
        return BookSortFactory.create(selection: selection)
    }

    private init() {}
}
