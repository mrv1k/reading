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
        case recent, author, title
    }

    var body: some View {
        List {
            Section(header:
                Text("Sort by:")
                    .frame(maxWidth: .infinity, alignment: .center)
            ) {
                ForEach(Sort.allCases) { sort in
                    Button(action: { print("mek") }) {
                        Text(sort.rawValue.capitalized)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
    }

}

struct BookSortMenu_Previews: PreviewProvider {
    static var previews: some View {
        BookSortMenu()
            .previewLayout(.sizeThatFits)
    }
}
