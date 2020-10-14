//
//  SessionListBook.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-10-07.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

struct SessionListBook: View {
    var book: Book

    var sessions: [Session] { book.sessions }

    let columns: [GridItem] =
        Array(repeating: .init(.flexible()), count: 4)

    var body: some View {
        ScrollView {
            VStack {
                Text("by " + book.author)
                Text(String(book.pageCount) + " pages")
            }

            LazyVGrid(columns: columns) {
                Text("start")
                Text("end")
                Text("progress")
                Text("%")
                ForEach(sessions) { session in
                    Text("\(session.pageStart)")
                    Text("\(session.pageEnd)")
                    Text("\(session.progressPage)")
                    Text("\(session.progressPercentRounded)%")
                }
                .padding(.top, 10)
            }
        }
        .navigationBarTitle(book.title, displayMode: .inline)
    }
}

struct SessionListBook_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SessionListBook(book: BookSeeder.preview.fetch(bookWith: .sessions))
        }
        .previewDevice("iPhone SE (2nd generation)")
    }
}
