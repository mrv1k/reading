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

    var book: Book?

    @State private var selectedDate = Date()
    
    @State private var pageStartField = ""
    @State private var pageEndField = ""
    @State private var pagesCompletedField = ""
    // @State private var pagesPreset = ""

    var body: some View {
        Form {
            ReadingSection(
                startField: $pageStartField,
                endField: $pageEndField,
                completedField: $pagesCompletedField)


            Section {
                if let book = book {
                    BookRow(book: book)
                } else {
                    BookSelect()
                }
            }


            Section {
                DatePickerWithTimeToggle(selection: $selectedDate)
            }

            // Text("timerStart?")
            // Text("timerEnd?")

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

fileprivate struct ReadingSection: View {
    @Binding var startField: String
    @Binding var endField: String
    @Binding var completedField: String

    var pageStart: Int {
        Int(startField) ?? 0
    }
    var pageEnd: Int {
        Int(endField) ?? 0
    }
    var pagesRead: Int {
        if pageEnd == 0 || pageStart == 0 {
            return 0
        }
        return pageEnd - pageStart
    }

    var body: some View {
        Section(header: Text("Pages")) {
            TextField("Start", text: $startField)
                .keyboardType(.numberPad)

            TextField("End", text: $endField)
                .keyboardType(.numberPad)

            HStack {
                // TODO: Computed / inputable
                TextField("Read", text: $completedField)

                // Picker("Preset", selection: $selection) {
                //     Text("10").tag("10")
                //     Text("15").tag("15")
                //     Text("20").tag("20")
                //     Text("25").tag("25")
                // }
                // .pickerStyle(MenuPickerStyle())
            }
        }
    }
}

fileprivate struct DatePickerWithTimeToggle: View {
    @Binding var selection: Date
    @State private var dateTimeToggle = false

    var displayedComponents: DatePickerComponents {
        var components: DatePickerComponents = .date
        if dateTimeToggle {
            components.insert(.hourAndMinute)
        }
        return components
    }

    var body: some View {
        // TODO: smooth animation, currently buggy in ios14 beta6
        Group {
            DatePicker(
                "Record on",
                selection: $selection,
                displayedComponents: displayedComponents)
            Toggle("Include time", isOn: $dateTimeToggle)
        }
    }
}

struct ReadingSessionCreate_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.shared.container.viewContext

        let book = BookSeeder(context: viewContext).insert(bookWith: .minimum)

        return Group {
            NavigationView {
                ReadingSessionCreate(book: book)
                    .navigationBarTitleDisplayMode(.inline)
            }

            ReadingSessionCreate(book: book)
        }
        .environment(\.managedObjectContext, viewContext)
    }
}
