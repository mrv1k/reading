//
//  BookExtension.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-10-13.
//  Copyright © 2020 mrv1k. All rights reserved.
//
import CoreData

extension Book {
    static var sortByTitle: NSSortDescriptor {
        return NSSortDescriptor(
            key: "title",
            ascending: true,
            selector: #selector(NSString.localizedStandardCompare(_:))
        )
    }

    static var sortByCreationDate: NSSortDescriptor {
        return NSSortDescriptor(keyPath: \Book.createdAt, ascending: true)
    }

    static var sortByAuthor: NSSortDescriptor {
        return NSSortDescriptor(
            key: "author",
            ascending: true,
            selector: #selector(NSString.localizedStandardCompare(_:))
        )
    }
}

extension Book {
    public var sessions: [Session] {
        sessionsSet?.array as? [Session] ?? []
    }

    // It's typically advised to avoid making to Array conversion
    // https://www.donnywals.com/reversing-an-array-in-swift/
    public var sessionsReversed: [Session] {
        sessionsSet?.reversed.array as? [Session] ?? []
    }
}
