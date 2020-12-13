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

    var controller: CDBookControllerContainer { unitOfWork.cdBookController }

    var body: some View {
        Picker("Sorting options", selection: $unitOfWork.cdBookController.sortSelection) {
            ForEach(BookSortSelection.allCases) { sort in
                if sort == controller.sortSelection {
                    Label(sort.rawValue, systemImage: controller.sortDirectionImage).tag(sort)
                } else {
                    Text(sort.rawValue).tag(sort)
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
