import Foundation
import SwiftUI
import CoreData

class SeedData {
    enum BookData: CaseIterable {
        case minimum, everything, subtitle
    }

    static let shared = SeedData()
    let moc: NSManagedObjectContext
    var counter = 0

    init() {
        guard let moc = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            fatalError("Unable to read managed object context.")
        }
        self.moc = moc
    }

    func makeBook(with data: BookData, save: Bool = false) -> Book {
        let book = Book(context: moc)
        book.id = UUID()
        print("make book #", counter)
        counter += 1

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
            book.pageCount = Int16(counter) // 500
        // book.image
        }

        if save {
            do {
                try moc.save()
            } catch {
                print(error)
            }
        }
        return book
    }

    func makeBookList(save: Bool = false) {
        let _ = makeBook(with: .minimum)
        let _ = makeBook(with: .subtitle)
        let _ = makeBook(with: .everything)


        if save {
            do {
                try moc.save()
            } catch {
                print(error)
            }
        }
    }

    func deleteBookList() {
        // let fetchBooks = NSFetchRequest<NSFetchRequestResult>(entityName: "Book")
        // let deleteBooks = NSBatchDeleteRequest(fetchRequest: fetchBooks)
        // do {
        //     try moc.execute(deleteBooks)
        // } catch {
        //     print(error)
        // }

        // https://stackoverflow.com/questions/1383598/core-data-quickest-way-to-delete-all-instances-of-an-entity
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Book")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        deleteRequest.resultType = .resultTypeObjectIDs

        do {
            let context = self.moc
            let result = try context.execute(
                deleteRequest
            )

            guard
                let deleteResult = result as? NSBatchDeleteResult,
                let ids = deleteResult.result as? [NSManagedObjectID]
            else { return }

            let changes = [NSDeletedObjectsKey: ids]
            NSManagedObjectContext.mergeChanges(
                fromRemoteContextSave: changes,
                into: [context]
            )
        } catch {
            print(error as Any)
        }

        // do {
        //     try moc.execute(deleteRequest)
        // } catch let error as NSError {
        //     print(error)
        // }
    }
}
