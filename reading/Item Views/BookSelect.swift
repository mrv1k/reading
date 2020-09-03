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
    @State private var isOpen: Bool = false
    var modal: BookListModal

    var body: some View {
        Button("Select a book") {
            self.isOpen = true
        }.sheet(isPresented: $isOpen, content: {
            modal
                .environment(\.managedObjectContext, viewContext)
        })
    }
}

// Preview crashes. SwiftUI Previews don't support modals?
