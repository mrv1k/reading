//
//  BookListSortMenu.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-08-21.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI
import Combine

struct BookListSortMenu: View {
    @Binding var sortDescriptor: NSSortDescriptor

    @State private var isOpen = false
    @State private var selectedSort: Sort

    init(sortDescriptor: Binding<NSSortDescriptor>) {
        _sortDescriptor = sortDescriptor
        let initialSort = convert(from: sortDescriptor.wrappedValue)
        _selectedSort = State(initialValue: initialSort)
    }

    var body: some View {
        // https://www.hackingwithswift.com/quick-start/swiftui/how-to-create-custom-bindings
        let selection = Binding<Sort> {
            selectedSort
        } set: { newSort in
            guard newSort != selectedSort else { return }
            selectedSort = newSort
            sortDescriptor = newSort.descriptor()
        }

        Picker("Sorting options", selection: selection) {
            ForEach(Sort.allCases) { sort in
                Text(sort.rawValue.capitalized).tag(sort)
            }
        }
    }
}

fileprivate enum Sort: String, CaseIterable, Identifiable {
    case title, author, date
    var id: String { rawValue }

    func descriptor() -> NSSortDescriptor {
        switch self {
        case .title: return Book.sortByTitle
        case .author: return Book.sortByAuthors
        case .date: return Book.sortByCreationDate
        }
    }
}

fileprivate func convert(from descriptor: NSSortDescriptor) -> Sort {
    switch descriptor {
    case Book.sortByTitle: return .title
    case Book.sortByAuthors: return .author
    case Book.sortByCreationDate: return .date
    default:
        #if DEBUG
        fatalError("Failed to initialize `initialSort` from `initialSortDescriptor`")
        #else
        return .title
        #endif
    }
}

struct BookListSortMenu_Previews: PreviewProvider {
    static var previews: some View {
        BookListSortMenu(sortDescriptor: .constant(Book.sortByTitle))
            .previewLayout(.sizeThatFits)
    }
}
