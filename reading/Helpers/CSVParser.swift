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
            print(csv.namedRows.first)
//            Optional(["End Page": "20", "Day": "1", "Book ": "\"Варкрафт: Хроники. Энциклопедия. Том 1\" by Blizzard Entertainment", "Total Pages": "176", "Start Page": "20", "Pages Read": "0", "Read": "11%", "Date": "01 Jul 2019"])
        } catch let parseError as CSVParseError {
            print(parseError)
            fatalError("errors from parsing invalid formed CSV")
        } catch {
            // Catch errors from trying to load files
        }
    }
}
