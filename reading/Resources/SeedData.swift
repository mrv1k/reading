import Foundation
import SwiftUI
import CoreData

class SeedData {
    static let shared = SeedData()
    let context: NSManagedObjectContext

    private init() {
        self.context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }

    func book1() -> Book {
        let book = Book(context: context)
        book.id = UUID()
        book.title = "Crime and Punishment"
        book.authors = "Fyodor Dostoyevsky"
        book.pageCount = Int16(1000)
        do {
            try context.save()
        } catch {
            print(error)
        }
        return book
    }

    // "Shoe Dog: A Memoir by the Creator of NIKE"
    func book2() -> Book {
        let book = Book(context: context)
        book.id = UUID()
        book.title = "Shoe Dog"
        book.subtitle = "A Memoir by the Creator of NIKE"
        book.authors = "Phil Knight"
        book.pageCount = Int16(400)
        do {
            try context.save()
        } catch {
            print(error)
        }
        return book
    }
}

// let book2 = Book(
//     id: 2,
//     title: "The Swift Programming Language",
//     subtitle: "(Swift 5.2 Edition)",
//     authors: ["Apple Inc.", "Another Author"],
//     pageCount: 500,
//     image: "swift_book_cover",
//     isEbook: true
// )
//
// let book3 = Book(
//     id: 3,
//     title: "Good Omens",
//     authors: ["Neil Gaiman", "Terry Pratchett"],
//     pageCount: 288
// )
//
// let sampleBookArray = [book0, book1, book2, book3]
//
// let sampleBookWith = [
//     "minimum": book0,
//     "subtitle": book1,
//     "everything": book2,
//     "2_authors": book3,
// ]
