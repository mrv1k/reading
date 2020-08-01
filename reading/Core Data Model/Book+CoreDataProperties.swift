//
//  Book+CoreDataProperties.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-08-01.
//  Copyright © 2020 mrv1k. All rights reserved.
//
//

import Foundation
import CoreData


extension Book {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book")
    }

    @NSManaged public var authors: String
    @NSManaged public var id: UUID
    @NSManaged public var image: Data?
    @NSManaged public var pageCount: Int16
    @NSManaged public var subtitle: String?
    @NSManaged public var title: String

}

extension Book : Identifiable {

}
