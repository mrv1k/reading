//
//  BookListSortPicker.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-08-21.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

struct BookListSortPicker: View {
    @EnvironmentObject private var unitOfWork: UnitOfWork

    var controller: CDBookStorage { unitOfWork.cdBookStorage }

    var chevron: String { controller.sort.isAscending ? "chevron.up" : "chevron.down" }

    var body: some View {
        Picker("Sorting options", selection: $unitOfWork.cdBookStorage.sortSelection) {
            ForEach(CDBookSort.Selection.allCases) { selection in
                if selection == controller.sortSelection {
                    Label(selection.rawValue, systemImage: chevron).tag(selection)
                } else {
                    Text(selection.rawValue).tag(selection)
                }
            }
        }
    }
}

struct BookListSortPicker_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.preview.container.viewContext
        let unitOfWork = UnitOfWork(context: viewContext)

        return Menu {
            BookListSortPicker()
        } label: {
            Image(systemName: "ellipsis.circle")
                .imageScale(.large)
                .padding()
        }
        .environmentObject(unitOfWork)
        .previewLayout(.sizeThatFits)
    }
}
