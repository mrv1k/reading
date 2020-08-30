//
//  BookListSortMenu.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-08-21.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

struct BookListSortMenu: View {
    @Binding var sortDescriptor: NSSortDescriptor

    @State private var isOpen = false
    @State private var selectedSort: Sort

    init(initialSortDescriptor: Binding<NSSortDescriptor>) {
        _sortDescriptor = initialSortDescriptor
        let initialSort = convert(from: initialSortDescriptor.wrappedValue)
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
            save(descriptor: sortDescriptor)
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

fileprivate func save(descriptor: NSSortDescriptor) {
    do {
        let savedData = try NSKeyedArchiver.archivedData(
            withRootObject: descriptor,
            requiringSecureCoding: true)
        UserDefaults.standard.setValue(savedData, forKey: "sortDescriptor")
    } catch {
        fatalError("failed to \(#function)")
    }
}

struct BookListSortMenu_Previews: PreviewProvider {
    static var previews: some View {
        LivePreviewWrapper()
    }

    // "Live Previews" https://stackoverflow.com/a/59626213
    struct LivePreviewWrapper: View {
        @State private var sortDescriptor: NSSortDescriptor = Book.sortByAuthors

        var body: some View {
            BookListSortMenu(initialSortDescriptor: $sortDescriptor)
                .previewLayout(.sizeThatFits)
        }
    }
}
