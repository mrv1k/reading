//
//  Book+CoreDataClass.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-07-29.
//  Copyright © 2020 mrv1k. All rights reserved.
//
//

import Foundation
import CoreData

public class Book: NSManagedObject {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        createdAt = Date()
    }

    // FIXME: either refactor 
    public override func willSave() {
        if sessions.count > 0 {
            // compute book completion percent
            let sum =
                sessions.map { $0.raw_progressPercent }
                .reduce(0, +)

            print(#function, sum)

            setPrimitiveValue(sum, forKey: "raw_completionPercent")
        }
    }
}
