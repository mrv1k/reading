//
//  ReadingSession+CoreDataProperties.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-10-07.
//  Copyright © 2020 mrv1k. All rights reserved.
//
//

import Foundation
import CoreData


extension ReadingSession {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ReadingSession> {
        return NSFetchRequest<ReadingSession>(entityName: "ReadingSession")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var pageEnd: Int64
    @NSManaged public var pageProgress: Int64
    @NSManaged public var pageStart: Int64
    @NSManaged public var percentProgress: Double
    @NSManaged public var book: Book?

}

extension ReadingSession : Identifiable {

}
