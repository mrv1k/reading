//
//  CDBookSort.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-12-15.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import CoreData

struct CDBookSort {
    private init() {}

    enum Selection: String, CaseIterable, Identifiable {
        case title = "Title"
        case author = "Author"
        case createdAt = "Date"

        var id: String { rawValue }

        var ascendingKey: UserDefaultsKey {
            switch self {
            case .author: return .sortByAuthorAscending
            case .createdAt: return .sortByCreatedAtAscending
            case .title: return .sortByTitleAscending
            }
        }
    }

    static var factory = Factory()
    static var loaded = factory.loadSort()

    // TODO: would be a smart idea to just convert Factory to a Manager and use that instead of saving on every change
    class Factory {
        fileprivate init() {}

        func create(selection: Selection, ascending: Bool? = nil, save: Bool = true) -> Sort {
            let isAscending = ascending != nil ? ascending! : loadAscending(selection: selection)

            let sort: Sort
            switch selection {
            case .author: sort = ByAuthor(isAscending: isAscending)
            case .title: sort = ByTitle(isAscending: isAscending)
            case .createdAt: sort = ByCreatedAt(isAscending: isAscending)
            }
            // Sort creation means sort is in use. Safe to save
            if save {
                saveSelection(selection: selection)
                saveAscending(sort.isAscending, selection: selection)
            }
            return sort
        }

        private func saveSelection(selection: Selection) {
            UserDefaults.standard.set(selection.rawValue, forKey: UserDefaultsKey.cdBookSort.rawValue)
        }

        fileprivate func loadSelection() -> Selection {
            guard let rawSelection = UserDefaults.standard.string(forKey: UserDefaultsKey.cdBookSort.rawValue)
            else { return .title }
            return Selection(rawValue: rawSelection)!
        }

        fileprivate func loadSort() -> Sort {
            let selection = loadSelection()
            return create(selection: selection, save: false)
        }

        private func saveAscending(_ value: Bool, selection: Selection) {
            UserDefaults.standard.set(value, forKey: selection.ascendingKey.rawValue)
        }

        private func loadAscending(selection: Selection) -> Bool {
            UserDefaults.standard.bool(forKey: selection.ascendingKey.rawValue)
        }
    }
}

protocol CDBookSortProtocol {
    var selection: CDBookSort.Selection { get }
    var isAscending: Bool { get set }
    var descriptor: NSSortDescriptor { get }
}

extension CDBookSort {
    typealias Sort = CDBookSortProtocol

    struct ByTitle: Sort {
        let selection: Selection = .title
        var isAscending: Bool
        var descriptor: NSSortDescriptor {
            NSSortDescriptor(
                key: #keyPath(Book.title),
                ascending: isAscending,
                selector: #selector(NSString.localizedStandardCompare(_:)))
        }
    }

    struct ByAuthor: Sort {
        let selection: Selection = .author
        var isAscending: Bool
        var descriptor: NSSortDescriptor {
            NSSortDescriptor(
                key: #keyPath(Book.author),
                ascending: isAscending,
                selector: #selector(NSString.localizedStandardCompare(_:)))
        }
    }

    struct ByCreatedAt: Sort {
        let selection: Selection = .createdAt
        var isAscending: Bool
        var descriptor: NSSortDescriptor {
            NSSortDescriptor(keyPath: \Book.createdAt, ascending: isAscending)
        }
    }
}
