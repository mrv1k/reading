//
//  CSVParser.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-12-03.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Foundation
import SwiftCSV

struct CSVParser {
    init() {
        guard let bundle = Bundle.main.path(forResource: "V.07.19", ofType: "csv") else {
            fatalError("could find the file")
        }
        let fileURL = URL(fileURLWithPath: bundle)

        do {
            let csv = try CSV(url: fileURL)
            print(csv.header)
            print(csv.namedRows.first!)
            print()

            let bookKey = csv.header
                .filter { $0.lowercased().contains("book") }
                .first!

            typealias CSVRow = [String: String]
            var sessionsByBooks = [String: [CSVRow]]()

            let bookCSV = csv.namedRows.forEach { (row: CSVRow) in
                let title = row[bookKey]!

                guard sessionsByBooks[title] != nil else {
                    sessionsByBooks[title] = [row]
                    return
                }
                sessionsByBooks[title]!.append(row)
            }

            sessionsByBooks.forEach {
                print($0.key, $0.value.count)
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
