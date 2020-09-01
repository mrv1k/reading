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
    @EnvironmentObject var userData: UserData

    @State var isModal: Bool = false
    var modal: some View {
        List {
            BookListSorted(
                sortDescriptor: userData.sortDescriptor,
                modalView: true) { book in
                print(book)
            }
        }
    }

    var body: some View {
        Button("Select a book") {
            self.isModal = true
        }.sheet(isPresented: $isModal, content: {
            modal
                .environment(\.managedObjectContext, viewContext)
                .environmentObject(userData)
        })
    }
}

// Preview crashes. SwiftUI Previews don't support modals?
