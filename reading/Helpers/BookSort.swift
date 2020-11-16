//
//  BookSort.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-11-12.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import CoreData

protocol BookSortProtocol {
    var labelName: String { get }
    var labelImage: String { get }

    var ascendingKey: UserDefaultsKey { get }
    var ascendingValue: Bool { get set }

    var sortKey: UserDefaultsKey { get }
    var sortValue: BookSortEnum { get }

    var descriptor: NSSortDescriptor { get }
    func save()
}

extension BookSortProtocol {
    var labelImage: String {
        ascendingValue ? "chevron.up" : "chevron.down"
    }
    var sortKey: UserDefaultsKey { .bookSort }
    func save() {
        UserDefaults.standard.set(sortValue.rawValue, forKey: sortKey.rawValue)
        UserDefaults.standard.set(ascendingValue, forKey: ascendingKey.rawValue)
    }
}

struct BookSort {
    static var shared = BookSort()

    private init() {}

    func makeStruct(sortSelector: BookSortEnum) -> BookSortProtocol {
        switch sortSelector {
        case .author: return SortByAuthor()
        case .title: return SortByTitle()
        case .createdAt: return SortByCreatedAt()
        }
    }
}

extension BookSort {
    struct SortByTitle: BookSortProtocol {
        var labelName = "Title"
        var ascendingKey: UserDefaultsKey { .sortByTitle }
        var ascendingValue = false
        var sortValue: BookSortEnum { .title }
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
        var labelName = "Author"
        var ascendingKey: UserDefaultsKey { .sortByAuthor }
        var ascendingValue = false
        var sortValue: BookSortEnum { .author }
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
        var labelName = "Date"
        var ascendingKey: UserDefaultsKey { .sortByCreatedAt }
        var ascendingValue = false
        var sortValue: BookSortEnum { .createdAt }
        var descriptor: NSSortDescriptor {
            NSSortDescriptor(keyPath: \Book.createdAt, ascending: ascendingValue)
        }

        init() {
            ascendingValue = UserDefaults.standard.bool(forKey: ascendingKey.rawValue)
        }
    }
}
