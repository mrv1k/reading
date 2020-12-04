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

            typealias CSVRow = [String: String]
            csv.namedRows.forEach { (row: CSVRow) in
                let title = row[titleKey]!
                let author = row[authorKey] ?? "Unknown"
                let pageCount = row[pagesCountKey]!


                let pageEnd = row[pageEndKey]!
                let createdAt = row[recordedDayKey]!

                var sessionRow = [
                    #keyPath(Session.pageEnd): pageEnd,
                    #keyPath(Session.createdAt): createdAt
                ]

                if sessionsByBooks[title] == nil {
                    sessionsByBooks[title] = []
                }
                sessionsByBooks[title]!.append(sessionRow)
            }

            sessionsByBooks.forEach { title, myRow in
                let book = Book(context: viewContext)
                book.title = title
                book.author = myRow
                let temp = myRow.first![pagesCountKey]!
                book.pageCount = Int16(temp)!
                print(title, myRow.count)
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
