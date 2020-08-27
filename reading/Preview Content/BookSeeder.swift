import Foundation
import UIKit
import CoreData

class BookSeeder {
    let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    enum Data: CaseIterable {
        case minimum, everything, subtitle, titleA, titleZ
    }

    @discardableResult func insert(bookWith data: Data, save: Bool = false) -> Book {
        let book = Book(context: context)

        switch data {
        case .minimum:
            book.title = "Crime and Punishment"
            book.authors = "Fyodor Dostoyevsky"
            book.pageCount = Int16(449)
        case .subtitle:
            book.title = "Shoe Dog: A Memoir by the Creator of NIKE"
            book.authors = "Phil Knight"
            book.pageCount = Int16(400)
        case .everything:
            book.title = "The Swift Programming Language (Swift 5.2 Edition)"
            book.authors = "Apple Inc., Second Author Example"
            book.pageCount = Int16(500)
        case .titleA:
            book.title = "Animal Farm"
            book.authors = "George Orwell"
            book.pageCount = Int16(122)
        case .titleZ:
            book.title = "Zorro"
            book.authors = "Isabel Allende, Margaret Sayers Peden (Translator)"
            book.pageCount = Int16(677)
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

    // FIXME: Do something with it
    // func deleteAll() {
    //     // let fetchBooks = NSFetchRequest<NSFetchRequestResult>(entityName: "Book")
    //     // let deleteBooks = NSBatchDeleteRequest(fetchRequest: fetchBooks)
    //     // do {
    //     //     try context.execute(deleteBooks)
    //     // } catch {
    //     //     print(error)
    //     // }
    //
    //     // https://stackoverflow.com/questions/1383598/core-data-quickest-way-to-delete-all-instances-of-an-entity
    //     let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Book")
    //     let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    //
    //     deleteRequest.resultType = .resultTypeObjectIDs
    //
    //     do {
    //         let context = self.context
    //         let result = try context.execute(
    //             deleteRequest
    //         )
    //
    //         guard
    //             let deleteResult = result as? NSBatchDeleteResult,
    //             let ids = deleteResult.result as? [NSManagedObjectID]
    //         else { return }
    //
    //         let changes = [NSDeletedObjectsKey: ids]
    //         NSManagedObjectContext.mergeChanges(
    //             fromRemoteContextSave: changes,
    //             into: [context]
    //         )
    //     } catch {
    //         print(error as Any)
    //     }
    //
    //     // public func executeAndMergeChanges(using batchDeleteRequest: NSBatchDeleteRequest) throws {
    //     //     batchDeleteRequest.resultType = .resultTypeObjectIDs
    //     //     let result = try execute(batchDeleteRequest) as? NSBatchDeleteResult
    //     //     let changes: [AnyHashable: Any] = [NSDeletedObjectsKey: result?.result as? [NSManagedObjectID] ?? []]
    //     //     NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [self])
    //     // }
    // }
}
