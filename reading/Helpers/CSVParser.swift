//
//  CSVParser.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-12-03.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import CoreData
import Foundation
import SwiftCSV

struct CSVParser {
    init(viewContext: NSManagedObjectContext) {
        guard let bundle = Bundle.main.path(forResource: "V.07.19", ofType: "csv") else {
            fatalError("Couldn't locate the file")
        }
        let fileURL = URL(fileURLWithPath: bundle)

        do {
            let csv = try CSV(url: fileURL)
            print(csv.header)
            print()

            let notFoundKey = ""
            let titleKey = csv.header
                .first { $0.lowercased().contains("book") } ?? notFoundKey

            let authorKey = csv.header
                .first { $0.lowercased().contains("author") } ?? notFoundKey

            let pagesCountKey = csv.header
                .first { $0.lowercased().contains("total pages") } ?? notFoundKey

            let pageEndKey = csv.header
                .first { $0.lowercased().contains("end page") } ?? notFoundKey

            let recordedDayKey = csv.header
                .first { $0.lowercased().contains("date") } ?? notFoundKey

            var sessionsByBooks = [String: [CSVRow]]()

            struct CSVBook {
                let title: String
                let author: String
                let pageCount: String
            }

            var books = [String: CSVBook]()


            typealias CSVRow = [String: String]
            csv.namedRows.forEach { (row: CSVRow) in
                let title = row[titleKey]! // FIXME: force unwrap

                if books[title] == nil {
                    var author = row[authorKey] ?? "Not found"
                    let pageCount = row[pagesCountKey]!

                    if title.contains(" by ") {
                        let titleAndAuthor = title.components(separatedBy: " by ")
                        author = titleAndAuthor.last!
                    }
                    let book = CSVBook(title: title, author: author, pageCount: pageCount)
                    books[title] = book
                }


//                let pageEnd = row[pageEndKey]!
//                let createdAt = row[recordedDayKey]!

//                if sessionsByBooks[title] == nil {
//                    sessionsByBooks[title] = []
//                }
//                sessionsByBooks[title]!.append(sessionRow)
            }

            books.forEach { csvBook in
                let book = Book(context: viewContext)
                book.title = csvBook.value.title
                book.author = csvBook.value.author
                book.pageCount = Int16(csvBook.value.pageCount)!
            }


//            sessionsByBooks.forEach { title, myRow in
//                let book = Book(context: viewContext)
//                book.title = title
//                book.author = "stub"
//                book.pageCount = Int16(100)
//                print(title, myRow.count)
//            }

//            sessions.reduce(into: [:]) { (result: inout [String: [Session]], session: Session) in
//                guard result[dateKey] != nil else { return result[dateKey] = [session] }
        } catch let parseError as CSVParseError {
            print(parseError)
            fatalError("errors from parsing invalid formed CSV")
        } catch {
            // Catch errors from trying to load files
        }
    }
}
