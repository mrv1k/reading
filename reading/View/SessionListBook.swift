//
//  SessionListBook.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-10-07.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

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

    var body: some View {
        LazyVStack {

            Group {
                // FIXME: replace with real date
                Text(dayFormatter.string(from: Date()))
                    .font(.headline)
                    .bold()
            }
            .frame(maxWidth: .infinity, alignment: .leading)


            ForEach(sessions) { session in
                VStack {
                    HStack {
                        Text("\(session.progressPage) pages")
                        Spacer()
                        Text(" on \(timeFormatter.string(from: session.createdAt))")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 1)

            Group {
                // FIXME: replace with real date
                Text(dayFormatter.string(from: Date() + 60 * 60 * 24))
                    .font(.headline)
                    .bold()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 20)

            VStack {
                HStack {
                    Text("\(sessions[0].progressPage) pages")
                    Spacer()
                    Text(" on \(timeFormatter.string(from: sessions[0].createdAt))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }


        }
        .frame(maxHeight: .infinity, alignment: .topLeading)
        .padding(.horizontal, 20)
    }
}

struct SessionListBook_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SessionListBook(book: BookSeeder.preview.fetch(bookWith: .sessions))
                .previewLayout(.sizeThatFits)

            NavigationView {
                SessionListBook(book: BookSeeder.preview.fetch(bookWith: .sessions))
            }
        }
        .previewDevice("iPhone SE (2nd generation)")
    }
}
