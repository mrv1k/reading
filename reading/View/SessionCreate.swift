//
//  SessionCreate.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-08-23.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

struct SessionCreate: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject var viewModel = SessionCreatePagesViewModel()

    var book: Book?
    @State private var bookSelection: Book?
    @State private var selectedDate = Date()

    var body: some View {
        Form {
            SessionCreatePagesSection(sectionViewModel: viewModel)

            Section {
                if let parentBook = book {
                    BookRow(book: parentBook)
                } else {
                    BookListModal(bookSelection: $bookSelection)
                    if let bookSelected = bookSelection {
                        BookRow(book: bookSelected)
                    }
                }
            }

            Section {
                DatePickerWithTimeToggle(selection: $selectedDate)
            }

            Section {
                Button("Save") {
                    print("wip")
                }
                .frame(maxWidth: .infinity)
            }

        }
        .navigationBarTitle(Text("Add a session"))
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
        Group {
            DatePicker(
                "Record on",
                selection: $selection,
                displayedComponents: displayedComponents)
            Toggle("Include time", isOn: $dateTimeToggle)
        }
    }
}

struct SessionCreate_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                SessionCreate()
                    .navigationBarTitleDisplayMode(.inline)
            }

            NavigationView {
                SessionCreate(book: BookSeeder.preview.fetch(bookWith: .minimum))
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
