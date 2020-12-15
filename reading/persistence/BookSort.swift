//
//  BookSort.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-11-12.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import CoreData

struct CDBookSort {
    private init() {}

    typealias Sort = CDBookSortProtocol

    enum Selection: String, CaseIterable, Identifiable {
        case title = "Title"
        case author = "Author"
        case createdAt = "Date"

        var id: String { rawValue }

        var ascendingKey: UserDefaultsKey {
            switch self {
            // FIXME: rename to better show that they are for asc/desc order
            case .author: return .sortByAuthor
            case .createdAt: return .sortByCreatedAt
            case .title: return .sortByTitle
            }
        }
    }

    static let factory = Factory()

    static let loadedSelection: Selection = factory.loadSelection()
    static let loadedSort: Sort = factory.loadSort()

    struct Factory {
        fileprivate init() {}

        func create(selection: Selection, ascending: Bool? = nil) -> Sort {
            let isAscending = ascending != nil ? ascending! : loadAscending(selection: selection)

            let sort: Sort
            switch selection {
            case .author: sort = ByAuthor(isAscending: isAscending)
            case .title: sort = ByTitle(isAscending: isAscending)
            case .createdAt: sort = ByCreatedAt(isAscending: isAscending)
            }
            // Sort creation means sort is in use. Safe to save
            // FIXME: should not fire on first load
            saveSelection(selection: selection)
            saveAscending(sort.isAscending, selection: selection)
            return sort
        }

        private func saveSelection(selection: Selection) {
            UserDefaults.standard.set(selection.rawValue, forKey: UserDefaultsKey.bookSort.rawValue)
        }

        fileprivate func loadSelection() -> Selection {
            guard let rawSelection = UserDefaults.standard.string(forKey: UserDefaultsKey.bookSort.rawValue)
            else { return .title }
            return Selection(rawValue: rawSelection)!
        }

        fileprivate func loadSort() -> Sort {
            let selection = loadSelection()
            let ascending = loadAscending(selection: selection)
            return create(selection: selection, ascending: ascending)
        }

        private func saveAscending(_ value: Bool, selection: Selection) {
            UserDefaults.standard.set(value, forKey: selection.ascendingKey.rawValue)
        }

        private func loadAscending(selection: Selection) -> Bool {
            UserDefaults.standard.bool(forKey: selection.ascendingKey.rawValue)
        }
    }
}

extension CDBookSort {
    struct ByTitle: Sort {
        var isAscending: Bool
        var descriptor: NSSortDescriptor {
            NSSortDescriptor(
                key: #keyPath(Book.title),
                ascending: isAscending,
                selector: #selector(NSString.localizedStandardCompare(_:)))
        }
    }

    struct ByAuthor: Sort {
        var isAscending: Bool
        var descriptor: NSSortDescriptor {
            NSSortDescriptor(
                key: #keyPath(Book.author),
                ascending: isAscending,
                selector: #selector(NSString.localizedStandardCompare(_:)))
        }
    }

    struct ByCreatedAt: Sort {
        var isAscending: Bool
        var descriptor: NSSortDescriptor {
            NSSortDescriptor(keyPath: \Book.createdAt, ascending: isAscending)
        }
    }
}

protocol CDBookSortProtocol {
    var isAscending: Bool { get set }
    var descriptor: NSSortDescriptor { get }
}
