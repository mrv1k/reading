//
//  ReadingSessionCreate.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-08-23.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

struct ReadingSessionCreate: View {
    @Environment(\.managedObjectContext) private var viewContext

    var book: Book

    @State private var selectedDate = Date()
    @State private var pageStartField = ""
    @State private var pageEndField = ""
    @State private var pagesReadField = ""
    @State private var selection = ""

    var pageStart: Int {
        Int(pageStartField) ?? 0
    }
    var pageEnd: Int {
        Int(pageEndField) ?? 0
    }
    var pagesRead: Int {
        if pageEnd == 0 || pageStart == 0 {
            return 0
        }
        return pageEnd - pageStart
    }

    private var dateClosedRange: ClosedRange<Date> {
        let min = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let max = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        return min...max
    }

    var body: some View {
        Form {
            Section {
                BookRow(book: book)
            }

            DatePicker(
                selection: $selectedDate,
                in: dateClosedRange,
                displayedComponents: .date,
                label: { Text("Date") }
            )

            Section {
                HStack {
                    TextField("Start page", text: $pageStartField)
                        .keyboardType(.numberPad)
                    TextField("End page", text: $pageEndField)
                        .keyboardType(.numberPad)
                }

                HStack {
                    TextField("Pages read", text: $pagesReadField)

                    Picker("Preset", selection: $selection) {
                        Text("10").tag("10")
                        Text("15").tag("15")
                        Text("20").tag("20")
                        Text("25").tag("25")
                    }
                    .pickerStyle(MenuPickerStyle())
                }
            }

            Text("timerStart?")
            Text("timerEnd?")

            Section {
                Button("Save") {
                    print("wip")
                }
                .frame(maxWidth: .infinity)
            }

        }
        .navigationBarTitle(Text("Add a sessions"))
    }
}

struct ReadingSessionCreate_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.shared.container.viewContext

        let book = BookSeeder(context: viewContext).insert(bookWith: .minimum)

        return Group {
            ReadingSessionCreate(book: book)

            NavigationView {
                ReadingSessionCreate(book: book)
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
        .environment(\.managedObjectContext, viewContext)
    }
}
