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
    struct CSVBook {
        let title: String
        let author: String
        let pageCount: String
    }

    struct CSVSession {
        let pageEnd: String
        let createdAt: String
    }

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

            var books = [String: CSVBook]()
            var sessions = [String: [CSVSession]]()

            csv.namedRows.forEach { (row: [String: String]) in
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

                if sessions[title] == nil {
                    sessions[title] = []
                }

                let pageEnd = row[pageEndKey]!
                let createdAt = row[recordedDayKey]!

                sessions[title]!.append(CSVSession(pageEnd: pageEnd, createdAt: createdAt))
            }

            books.forEach { csvBook in
                let book = Book(context: viewContext)
                book.title = csvBook.value.title
                book.author = csvBook.value.author
                book.pageCount = Int16(csvBook.value.pageCount)!

                sessions[csvBook.key]!.forEach { csvSession in
                    let session = Session(context: viewContext)
                    session.book = book
                    session.pageEnd = Int16(csvSession.pageEnd)!
                    session.computeMissingAttributes()

                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd MMM yyyy"
                    session.createdAt = dateFormatter.date(from: csvSession.createdAt) ?? session.createdAt
                }
            }
        } catch let parseError as CSVParseError {
            print(parseError)
            fatalError("errors from parsing invalid formed CSV")
        } catch {
            // Catch errors from trying to load files
        }
    }
}
