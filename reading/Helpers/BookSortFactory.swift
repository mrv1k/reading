//
//  BookSortFactory.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-11-12.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import CoreData

protocol BookSortProtocol {
    var labelImage: String { get }
    var ascendingKey: UserDefaultsKey { get }
    var ascendingValue: Bool { get set }
    var sortValue: BookSortSelection { get }
    var descriptor: NSSortDescriptor { get }
}

extension BookSortProtocol {
    var labelImage: String { ascendingValue ? "chevron.up" : "chevron.down" }
}

struct BookSortFactory {
    static var shared = BookSortFactory()
    private init() {}

    var latest = InitialBookSort.shared.sort
    var latestSelection = InitialBookSort.shared.selection

    mutating func create(selection: BookSortSelection) -> BookSortProtocol {
        print("create")
        switch selection {
        case .author: latest = SortByAuthor()
        case .title: latest = SortByTitle()
        case .createdAt: latest = SortByCreatedAt()
        }
        return latest
    }

    func saveLatest() {
        UserDefaults.standard.set(latest.sortValue.rawValue, forKey: UserDefaultsKey.bookSort.rawValue)
        UserDefaults.standard.set(latest.ascendingValue, forKey: latest.ascendingKey.rawValue)
    }
}

extension BookSortFactory {
    struct SortByTitle: BookSortProtocol {
        var ascendingKey: UserDefaultsKey { .sortByTitle }
        var ascendingValue = false
        var sortValue: BookSortSelection { .title }
        var descriptor: NSSortDescriptor {
            NSSortDescriptor(
                key: #keyPath(Book.title),
                ascending: ascendingValue,
                selector: #selector(NSString.localizedStandardCompare(_:)))
        }

        init() {
            ascendingValue = UserDefaults.standard.bool(forKey: ascendingKey.rawValue)
        }
    }

    struct SortByAuthor: BookSortProtocol {
        var ascendingKey: UserDefaultsKey { .sortByAuthor }
        var ascendingValue = false
        var sortValue: BookSortSelection { .author }
        var descriptor: NSSortDescriptor {
            NSSortDescriptor(
                key: #keyPath(Book.author),
                ascending: ascendingValue,
                selector: #selector(NSString.localizedStandardCompare(_:)))
        }

        init() {
            ascendingValue = UserDefaults.standard.bool(forKey: ascendingKey.rawValue)
        }
    }

    struct SortByCreatedAt: BookSortProtocol {
        var ascendingKey: UserDefaultsKey { .sortByCreatedAt }
        var ascendingValue = false
        var sortValue: BookSortSelection { .createdAt }
        var descriptor: NSSortDescriptor {
            NSSortDescriptor(keyPath: \Book.createdAt, ascending: ascendingValue)
        }

        init() {
            ascendingValue = UserDefaults.standard.bool(forKey: ascendingKey.rawValue)
        }
    }
}

fileprivate struct InitialBookSort {
    static var shared = InitialBookSort()
    private init() {}

    var selection: BookSortSelection { loadSavedSort() ?? .title }
    var sort: BookSortProtocol { BookSortFactory.shared.create(selection: selection) }

    private func loadSavedSort() -> BookSortSelection? {
        if let savedSort = UserDefaults.standard.string(forKey: UserDefaultsKey.bookSort.rawValue) {
            return BookSortSelection.init(rawValue: savedSort)
        }
        return nil
    }
}

