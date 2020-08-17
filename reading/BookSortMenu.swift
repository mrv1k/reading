//
//  BookSortMenu.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-08-16.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

struct BookSortMenu: View {
    enum Sort: String, CaseIterable, Identifiable {
        var id: String { self.rawValue }
        case recent = "Recent"
        case title = "Title"
        case author = "Author"
    }
    @State var displayingSort = false
    @State var selectedSort: Sort = .recent

    var sortSheet: ActionSheet {
        ActionSheet(
            title: Text("Sort by:"),
            buttons: [
                .default(Text(Sort.recent.rawValue), action: {
                    self.selectedSort = .recent
                }),
                .default(Text(Sort.title.rawValue), action: {
                    self.selectedSort = .title
                }),
                .default(Text(Sort.author.rawValue), action: {
                    self.selectedSort = .author
                }),
                .cancel({
                    // reset to last sort
                })
            ]
        )
    }

    var body: some View {
        Button("Sort by: \(selectedSort.rawValue)") {
            self.displayingSort = true
        }
        .actionSheet(isPresented: $displayingSort) { () -> ActionSheet in
            self.sortSheet
        }
    }
}

struct BookSortMenu_Previews: PreviewProvider {
    static var previews: some View {
        BookSortMenu()
            .previewLayout(.sizeThatFits)
    }
}
