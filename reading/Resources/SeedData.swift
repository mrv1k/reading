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

    private func minimum(book: Book) {
        book.title = "Crime and Punishment"
        book.authors = "Fyodor Dostoyevsky"
        book.pageCount = Int16(449)
    }

    // "Shoe Dog: A Memoir by the Creator of NIKE"
    private func everything(book: Book) {
        book.title = "Shoe Dog"
        book.subtitle = "A Memoir by the Creator of NIKE"
        book.authors = "Phil Knight"
        book.pageCount = Int16(400)
    }

    private func subtitle(book: Book) {
        book.title = "The Swift Programming Language"
        book.subtitle = "(Swift 5.2 Edition)"
        book.authors = "Apple Inc., Elppa Cin."
        book.pageCount = Int16(500)
    }

    func makeBook(with data: BookData, save: Bool = false) -> Book {
        let book = Book(context: moc)
        book.id = UUID()

        switch data {
        case .minimum:
            minimum(book: book)
        case .everything:
            everything(book: book)
        case .subtitle:
            subtitle(book: book)
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

    // TODO make seed book list
}
