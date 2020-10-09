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

@objc(Book)
public class Book: NSManagedObject {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        createdAt = Date()
    }
}
