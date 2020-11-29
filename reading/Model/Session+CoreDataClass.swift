//
//  Session+CoreDataClass.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-10-09.
//  Copyright © 2020 mrv1k. All rights reserved.
//
//

import CoreData
import Foundation

public class Session: NSManagedObject {
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        setPrimitiveValue(UUID(), forKey: "id")
        setPrimitiveValue(Date(), forKey: "createdAt")
    }

    @objc class func keyPathsForValuesAffectingProgressPercent() -> Set<NSObject> {
        [#keyPath(Session.raw_progressPercent) as NSObject]
    }

    @objc dynamic var progressPercent: Int {
        Int(Helpers.percentCalculator.rounded(raw_progressPercent))
    }
}
