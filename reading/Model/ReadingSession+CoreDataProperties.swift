//
//  ReadingSession+CoreDataProperties.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-08-23.
//  Copyright © 2020 mrv1k. All rights reserved.
//
//

import Foundation
import CoreData


extension ReadingSession {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ReadingSession> {
        return NSFetchRequest<ReadingSession>(entityName: "ReadingSession")
    }

    @NSManaged public var date: Date?
    @NSManaged public var pageEnd: Int16
    @NSManaged public var pagesRead: Int16
    @NSManaged public var pageStart: Int16
    @NSManaged public var timerDuration: Date?
    @NSManaged public var timerEnd: Date?
    @NSManaged public var timerStart: Date?
    @NSManaged public var book: Book?

}
