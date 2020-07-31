import Foundation
import SwiftUI
import CoreData

class SeedData {
    enum BookData: CaseIterable {
        case minimum, everything, subtitle
    }

    static let shared = SeedData()
    let moc: NSManagedObjectContext

    private init() {
        guard let moc = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            fatalError("Unable to read managed object context.")
        }
        self.moc = moc
    }

    func makeBook(with data: BookData, save: Bool = false) -> Book {
        let book = Book(context: moc)
        book.id = UUID()

        switch data {
        case .minimum:
            book.title = "Crime and Punishment"
            book.authors = "Fyodor Dostoyevsky"
            book.pageCount = Int16(449)
        case .subtitle:
            book.title = "Shoe Dog"
            book.subtitle = "A Memoir by the Creator of NIKE"
            book.authors = "Phil Knight"
            book.pageCount = Int16(400)
        case .everything:
            book.title = "The Swift Programming Language"
            book.subtitle = "(Swift 5.2 Edition)"
            book.authors = "Apple Inc., Second Author Example"
            book.pageCount = Int16(500)
            // book.image
        }

        if save {
            moc.performAndWait {
                do {
                    try moc.save()
                } catch {
                    print(error)
                }
            }
        }
        return book
    }

    func makeBookList(save: Bool = false) {
        let _ = makeBook(with: .minimum)
        let _ = makeBook(with: .subtitle)
        let _ = makeBook(with: .everything)

        moc.performAndWait {
            if save {
                do {
                    try moc.save()
                } catch {
                    print(error)
                }
            }
        }
    }
}
