//
//  BookSelect.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-08-31.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

struct BookSelect: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State var isModal: Bool = false

    var body: some View {
        Button("Select a book") {
            self.isModal = true
        }.sheet(isPresented: $isModal, content: {
            // BookListModal()
            Text("placeholder")
                .environment(\.managedObjectContext, viewContext)
        })
    }
}

// Preview crashes. SwiftUI Previews don't support modals?
