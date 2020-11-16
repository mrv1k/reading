//
//  BookSort.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-11-12.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import CoreData

struct InitialBookSort {
    static var shared = InitialBookSort()
    private init() {}

    var selection: BookSortMenuOption { loadSavedSort() ?? .title }
    var sort: BookSortProtocol { BookSort.shared.makeStruct(sortSelector: selection) }

    private func loadSavedSort() -> BookSortMenuOption? {
        if let savedSort = UserDefaults.standard.string(forKey: UserDefaultsKey.bookSort.rawValue) {
            return BookSortMenuOption.init(rawValue: savedSort)
        }
        return nil
    }
}

protocol BookSortProtocol {
    var labelImage: String { get }
    var ascendingKey: UserDefaultsKey { get }
    var ascendingValue: Bool { get set }
    var sortValue: BookSortMenuOption { get }
    var descriptor: NSSortDescriptor { get }
}

extension BookSortProtocol {
    var labelImage: String { ascendingValue ? "chevron.up" : "chevron.down" }
}

struct BookSort {
    static var shared = BookSort()
    private init() {}

    func makeStruct(sortSelector: BookSortMenuOption) -> BookSortProtocol {
        switch sortSelector {
        case .author: return SortByAuthor()
        case .title: return SortByTitle()
        case .createdAt: return SortByCreatedAt()
        }
    }

    func save(sort: BookSortProtocol) {
        UserDefaults.standard.set(sort.sortValue.rawValue, forKey: UserDefaultsKey.bookSort.rawValue)
        UserDefaults.standard.set(sort.ascendingValue, forKey: sort.ascendingKey.rawValue)
    }
}

extension BookSort {
    struct SortByTitle: BookSortProtocol {
        var ascendingKey: UserDefaultsKey { .sortByTitle }
        var ascendingValue = false
        var sortValue: BookSortMenuOption { .title }
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
        var sortValue: BookSortMenuOption { .author }
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
        var sortValue: BookSortMenuOption { .createdAt }
        var descriptor: NSSortDescriptor {
            NSSortDescriptor(keyPath: \Book.createdAt, ascending: ascendingValue)
        }

        init() {
            ascendingValue = UserDefaults.standard.bool(forKey: ascendingKey.rawValue)
        }
    }
}
