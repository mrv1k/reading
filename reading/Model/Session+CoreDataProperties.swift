//
//  Session+CoreDataProperties.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-11-29.
//  Copyright © 2020 mrv1k. All rights reserved.
//
//

import Foundation
import CoreData


extension Session {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Session> {
        return NSFetchRequest<Session>(entityName: "Session")
    }

    @NSManaged public var createdAt: Date
    @NSManaged public var id: UUID
    @NSManaged public var pageEnd: Int16
    @NSManaged public var pageStart: Int16
    @NSManaged public var progressPage: Int16
//    @NSManaged public var progressPercent: Int16
    @NSManaged public var raw_progressPercent: Int16
    @NSManaged public var updatedAt: Date?
    @NSManaged public var book: Book?

}

extension Session : Identifiable {

}
