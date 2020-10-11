//
//  Session+CoreDataProperties.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-10-11.
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
    @NSManaged public var pageEnd: Int16
    @NSManaged public var pageStart: Int16
    @NSManaged public var progressPage: Int16
    @NSManaged public var progressPercent: Float
    @NSManaged public var updatedAt: Date?
    @NSManaged public var book: Book?

}

extension Session : Identifiable {

}

extension Session {
    public func autofillProgress() {
        // TODO: dont write start if it exists

        if let book = book {
            if book.sessions.count == 1 {
                pageStart = 1
            } else {
                // - 1 for count, - 1 for current session = -2
                pageStart = book.sessions[book.sessions.count - 2].pageEnd
            }

            progressPage = pageEnd - pageStart
            print(book.pageCount, progressPage)
            print(Float(progressPage) / 100)
        }
    }
}
