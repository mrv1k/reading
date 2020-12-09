//
//  Book+CoreDataProperties.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-12-05.
//  Copyright © 2020 mrv1k. All rights reserved.
//
//

import Foundation
import CoreData


extension Book {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book")
    }

    @NSManaged public var author: String
    @NSManaged public var completionPage: Int16
    @NSManaged public var createdAt: Date
    @NSManaged public var id: UUID
    @NSManaged public var pageCount: Int16
    @NSManaged public var raw_completionPercent: Int16
    @NSManaged public var readTimes: Int16
    @NSManaged public var sessionCount: Int16
    @NSManaged public var title: String
    @NSManaged public var updatedAt: Date?
    @NSManaged public var completed: Bool
    @NSManaged public var sessionsSet: NSOrderedSet?

}

// MARK: Generated accessors for sessionsSet
extension Book {

    @objc(insertObject:inSessionsSetAtIndex:)
    @NSManaged public func insertIntoSessionsSet(_ value: Session, at idx: Int)

    @objc(removeObjectFromSessionsSetAtIndex:)
    @NSManaged public func removeFromSessionsSet(at idx: Int)

    @objc(insertSessionsSet:atIndexes:)
    @NSManaged public func insertIntoSessionsSet(_ values: [Session], at indexes: NSIndexSet)

    @objc(removeSessionsSetAtIndexes:)
    @NSManaged public func removeFromSessionsSet(at indexes: NSIndexSet)

    @objc(replaceObjectInSessionsSetAtIndex:withObject:)
    @NSManaged public func replaceSessionsSet(at idx: Int, with value: Session)

    @objc(replaceSessionsSetAtIndexes:withSessionsSet:)
    @NSManaged public func replaceSessionsSet(at indexes: NSIndexSet, with values: [Session])

    @objc(addSessionsSetObject:)
    @NSManaged public func addToSessionsSet(_ value: Session)

    @objc(removeSessionsSetObject:)
    @NSManaged public func removeFromSessionsSet(_ value: Session)

    @objc(addSessionsSet:)
    @NSManaged public func addToSessionsSet(_ values: NSOrderedSet)

    @objc(removeSessionsSet:)
    @NSManaged public func removeFromSessionsSet(_ values: NSOrderedSet)

}

extension Book : Identifiable {

}
