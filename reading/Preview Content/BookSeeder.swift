//
//  BookSeeder.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-10-13.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import CoreData

struct BookSeeder {
    static let preview = BookSeeder(viewContext: PersistenceController.preview.container.viewContext)

    private let context: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        context = viewContext
    }

    enum Data: String, CaseIterable {
        case test = "Title"
        case minimum = "Crime and Punishment"
        case everything = "Shoe Dog: A Memoir by the Creator of NIKE"
        case subtitle = "The Swift Programming Language (Swift 5.2 Edition)"
        case titleA = "Animal Farm"
        case titleZ = "Zorro"
    }

    func fetch(bookWith: Data) -> Book {
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", bookWith.rawValue)
        return (try! context.fetch(fetchRequest) as [Book]).first!
    }

    func insert(bookWith data: Data) {
        let book = Book(context: context)
        book.title = data.rawValue

        switch data {
        case .test:
            book.author = "Firstname Lastname"
            book.pageCount = 101
        case .minimum:
            book.author = "Fyodor Dostoyevsky"
            book.pageCount = 449
        case .subtitle:
            book.author = "Phil Knight"
            book.pageCount = 400
        case .everything:
            book.author = "Apple Inc., Second Author Example"
            book.pageCount = 500
        case .titleA:
            book.author = "George Orwell"
            book.pageCount = 122
        case .titleZ:
            book.author = "Isabel Allende, Margaret Sayers Peden (Translator)"
            book.pageCount = 677
        }
    }

    func insertAll() {
        for data in Data.allCases {
            insert(bookWith: data)
        }
    }
}
