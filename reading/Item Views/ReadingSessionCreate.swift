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
    @State var selectedDate = Date()

    var dateClosedRange: ClosedRange<Date> {
        let min = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let max = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        return min...max
    }

    var body: some View {
        Form {
            Section(header: Text("Book")) {
                Text("\(book.title) by \(book.authors)")
            }

            DatePicker(
                selection: $selectedDate,
                in: dateClosedRange,
                displayedComponents: .date,
                label: { Text("Session Date") }
            )

            Text("pageStart")
            Text("pageEnd")
            Text("computed pagesRead")

            Text("timerStart?")
            Text("timerEnd?")
        }
        .navigationBarTitle(Text("Add reading sessions"))
    }
}

struct ReadingSessionCreate_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.shared.container.viewContext

        let book = BookSeeder(context: viewContext).insert(bookWith: .minimum)

        return NavigationView {
            ReadingSessionCreate(book: book)
                .environment(\.managedObjectContext, viewContext)
        }
    }
}
