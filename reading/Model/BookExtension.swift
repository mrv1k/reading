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
        return sessionsSet?.array as? [Session] ?? []
        // let sessionSet = sessionsSet as? Set<Session> ?? []
        // return sessionSet.sorted { $0.createdAt < $1.createdAt }
    }
}
