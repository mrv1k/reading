//
//  Session+CoreDataProperties.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-10-13.
//  Copyright © 2020 mrv1k. All rights reserved.
//
//

import Foundation
import CoreData


extension Session {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Session> {
        return NSFetchRequest<Session>(entityName: "Session")
    }

    @NSManaged public var createdAt: Date //?
    @NSManaged public var pageEnd: Int16
    @NSManaged public var pageStart: Int16
    @NSManaged public var progressPage: Int16
    @NSManaged public var progressPercent: Int16
    @NSManaged public var updatedAt: Date?
    @NSManaged public var book: Book?

}

extension Session : Identifiable {

}

extension Session {
    private func calculatePercentage(part: Int16, total: Int16) -> Int16 {
        let percentage = Float(part) / Float(total) * 100
        // multiply by 10 to keep 1 fractional number
        return Int16((percentage * 10).rounded())
    }

    public func autofillProgress() {
        // TODO: dont write start if it exists

        if let book = book {
            if book.sessions.count == 1 {
                pageStart = 0
            } else {
                // - 1 for count, - 1 for current session
                pageStart = book.sessions[book.sessions.count - 2].pageEnd
            }

            progressPage = pageEnd - pageStart
            progressPercent = calculatePercentage(part: progressPage, total: book.pageCount)
        }
    }
}
