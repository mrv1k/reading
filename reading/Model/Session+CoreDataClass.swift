//
//  Session+CoreDataClass.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-10-09.
//  Copyright © 2020 mrv1k. All rights reserved.
//
//

import Foundation
import CoreData


public class Session: NSManagedObject {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        createdAt = Date()
    }
}
