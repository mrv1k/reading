import Foundation
import UIKit
import CoreData

class BookSeeder {
    let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    enum Data: String, CaseIterable {
        case test = "Title"
        case minimum = "Crime and Punishment"
        case everything = "Shoe Dog: A Memoir by the Creator of NIKE"
        case subtitle = "The Swift Programming Language (Swift 5.2 Edition)"
        case titleA = "Animal Farm"
        case titleZ = "Zorro"
    }

    func fetch(book: Data) -> Book {
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", book.rawValue)
        return (try! context.fetch(fetchRequest) as [Book]).first!
    }

    @discardableResult func insert(bookWith data: Data, save: Bool = false) -> Book {
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

        if save {
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
        return book
    }

    fileprivate func count() -> Int {
        do {
            return try context.count(for: Book.fetchRequest())
        } catch {
            fatalError("book count failed")
        }
    }

    func insertAllCases(seedOnce: Bool = false, save: Bool = false) {
        if seedOnce && count() != 0 {
            return
        }

        for data in Data.allCases {
            insert(bookWith: data)
        }

        if save {
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
}
