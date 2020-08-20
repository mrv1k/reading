//
//  AppleExtensions.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-08-19.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    // https://www.avanderlee.com/swift/core-data-performance/
    // Only perform changes if there are changes to commit
    @discardableResult public func saveOnChanges() throws -> Bool {
        guard hasChanges else { return false }
        try save()
        return true
    }
}
