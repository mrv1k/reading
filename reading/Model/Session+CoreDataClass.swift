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
        setPrimitiveValue(Date(), forKey: "createdAt")
    }
}
