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

    @Binding var pageProgress: Bool
    @Binding var timeStyle: Text.DateStyle

    var body: some View {
        LazyVStack {
            ForEach(sessions) { (session: Session) in
                SessionRow(viewModel: .init(session: session))
            }
        }
        .frame(maxHeight: .infinity, alignment: .topLeading)
        .padding(.horizontal, 20)
    }
}

struct SessionListBook_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SessionListBook(
                book: BookSeeder.preview.fetch(bookWith: .sessions),
                pageProgress: .constant(true),
                timeStyle: .constant(.time)
            )
            .previewLayout(.sizeThatFits)

            NavigationView {
                SessionListBook(
                    book: BookSeeder.preview.fetch(bookWith: .sessions),
                    pageProgress: .constant(false),
                    timeStyle: .constant(.relative)
                )
            }
        }
        .previewDevice("iPhone SE (2nd generation)")
    }
}
