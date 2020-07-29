//
//  Book+CoreDataProperties.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-07-29.
//  Copyright © 2020 mrv1k. All rights reserved.
//
//

import Foundation
import CoreData


extension Book: Identifiable {

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
