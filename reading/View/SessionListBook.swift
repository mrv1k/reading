//
//  SessionListBook.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-10-07.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

// FIXME: move to session
private var timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    return formatter
}()
private var dayFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "E d MMM"
    return formatter
}()

struct SessionListBook: View {
    var book: Book
    var sessions: [Session] { book.sessions }

    @Binding var pageProgress: Bool

    var body: some View {
        LazyVStack {
            Group {
                // FIXME: replace with real date
                // FIXME: Show only with 1 session
                Text(dayFormatter.string(from: Date()))
                    .font(.headline)
                    .bold()
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            ForEach(sessions) { (session: Session) in
                VStack {
                    HStack {
                        Group {
                            if pageProgress == true {
                                Text("\(session.progressPage) pages")
                            } else {
                                Text("\(session.progressPercent)%")
                            }
                        }
                        .onTapGesture {
                            pageProgress.toggle()
                        }

                        Spacer()
                        Text(" on \(timeFormatter.string(from: session.createdAt))")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 1)
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
                pageProgress: .constant(true)
            )
            .previewLayout(.sizeThatFits)

            NavigationView {
                SessionListBook(
                    book: BookSeeder.preview.fetch(bookWith: .sessions),
                    pageProgress: .constant(false)
                )
            }
        }
        .previewDevice("iPhone SE (2nd generation)")
    }
}
