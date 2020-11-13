//
//  BookSort.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-11-12.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import CoreData

enum BookSort: String, CaseIterable, Identifiable {
    case title = "Title"
    case author = "Author"
    case createdAt = "Date"

    var id: String { rawValue }

    func descriptor(ascending: Bool) -> NSSortDescriptor {
        switch self {
        case .title: return byTitle(ascending: ascending)
        case .author: return byAuthor(ascending: ascending)
        case .createdAt: return byCreatedAt(ascending: ascending)
        }
    }

    func byTitle(ascending: Bool) -> NSSortDescriptor {
        NSSortDescriptor(
            key: #keyPath(Book.title),
            ascending: ascending,
            selector: #selector(NSString.localizedStandardCompare(_:))
        )
    }

    func byCreatedAt(ascending: Bool) -> NSSortDescriptor {
        NSSortDescriptor(keyPath: \Book.createdAt, ascending: ascending)
    }

    func byAuthor(ascending: Bool) -> NSSortDescriptor {
        NSSortDescriptor(
            key: #keyPath(Book.author),
            ascending: ascending,
            selector: #selector(NSString.localizedStandardCompare(_:))
        )
    }

}
