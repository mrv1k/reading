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

            let titleKey = csv.header
                .first { $0.lowercased().contains("book")}!

            let authorKey = csv.header
                .first { $0.lowercased().contains("author")}

            let pagesCountKey = csv.header
                .first { $0.lowercased().contains("total pages")}!

//            bookToCSVMap
            _ = [
                #keyPath(Book.title): titleKey,
                #keyPath(Book.author): authorKey,
                #keyPath(Book.pageCount): pagesCountKey
            ]

            typealias CSVRow = [String: String]
            var sessionsByBooks = [String: [CSVRow]]()

            csv.namedRows.forEach { (row: CSVRow) in
                let title = row[titleKey]!

                guard sessionsByBooks[title] != nil else {
                    sessionsByBooks[title] = [row]
                    return
                }
                sessionsByBooks[title]!.append(row)
            }

            sessionsByBooks.forEach { (title, csvRow) in
                let book = Book(context: viewContext)
                book.title = title
                book.author = "Unknown"
                let temp = csvRow.first![pagesCountKey]!
                book.pageCount = Int16(temp)!
                print(title, csvRow.count)
            }

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
