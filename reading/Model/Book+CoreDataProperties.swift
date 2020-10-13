//
//  Book+CoreDataProperties.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-10-13.
//  Copyright © 2020 mrv1k. All rights reserved.
//
//

import Foundation
import CoreData


extension Book {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book")
    }

    @NSManaged public var author: String //?
    @NSManaged public var createdAt: Date //?
    @NSManaged public var pageCount: Int16
    @NSManaged public var completionPercent: Double
    @NSManaged public var readTimes: Int16
    @NSManaged public var title: String //?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var sessionsSet: NSSet?

}

// MARK: Generated accessors for sessionsSet
extension Book {

    @objc(addSessionsSetObject:)
    @NSManaged public func addToSessionsSet(_ value: Session)

    @objc(removeSessionsSetObject:)
    @NSManaged public func removeFromSessionsSet(_ value: Session)

    @objc(addSessionsSet:)
    @NSManaged public func addToSessionsSet(_ values: NSSet)

    @objc(removeSessionsSet:)
    @NSManaged public func removeFromSessionsSet(_ values: NSSet)

}

extension Book : Identifiable {

}

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
        let sessionSet = sessionsSet as? Set<Session> ?? []
        return sessionSet.sorted { $0.createdAt < $1.createdAt }
    }
}
