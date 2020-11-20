//
//  Book+CoreDataClass.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-07-29.
//  Copyright © 2020 mrv1k. All rights reserved.
//
//

import CoreData
import Foundation

public class Book: NSManagedObject {
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        setPrimitiveValue(Date(), forKey: "createdAt")
    }

    @objc class func keyPathsForValuesAffectingSessions() -> Set<NSObject> {
        [#keyPath(Book.sessionsSet) as NSObject]
    }
}
