//
//  BookListSortPicker.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-08-21.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

import Combine


enum BookSortEnum: String, CaseIterable, Identifiable {
    case title = "Title"
    case author = "Author"
    case createdAt = "Date"

    var id: String { rawValue }
}

enum BookSortAction {
    case changeSort, toggleDirection
}

class BookListSortPickerViewModel: ObservableObject {
    @Published var selection: BookSortEnum

    init(initSelector: BookSortEnum) {
        selection = initSelector
    }

    var actionPublisher: AnyPublisher<BookSortAction, Never> {
        $selection
            .dropFirst()
            .map({ newSelection -> BookSortAction in
//                print("actionPublisher", newSelection)
                // if current and new sort are the same, toggle sort direction
//                if self.selection == newSelection { return .toggleDirection }
//                return .changeSort
                self.selection == newSelection ? .toggleDirection : .changeSort
            })
            .eraseToAnyPublisher()
    }
}

struct BookListSortPicker: View {
    @ObservedObject var viewModel: BookListSortPickerViewModel

    var body: some View {
        Picker("Sorting options", selection: $viewModel.selection) {
            ForEach(BookSortEnum.allCases) { sort in
                if viewModel.selection == sort {
                    Text(sort.rawValue).tag(sort)
//                    Label("sort.computedStruct.labelName", systemImage: "sort.computedStruct.labelImage").tag(sort)
                } else {
                    Text(sort.rawValue).tag(sort)
                }
            }
        }
    }
}

//struct BookListSortPicker_Previews: PreviewProvider {
//    static var previews: some View {
//        Menu {
//            BookListSortPicker(bookSort: .constant(BookSort.init(rawValue: "author")!))
//        } label: {
//            Image(systemName: "ellipsis.circle")
//                .imageScale(.large)
//                .padding()
//        }
//        .previewLayout(.sizeThatFits)
//    }
//}
