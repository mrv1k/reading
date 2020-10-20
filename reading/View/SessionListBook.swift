//
//  SessionListBook.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-10-07.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

// FIXME: move to session
private var dayFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "E"
    return formatter
}()

private var calendarDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "d MMM"
    return formatter
}()

struct SessionListBook: View {
    var book: Book
    var sessions: [Session] { book.sessions }

    @Binding var pageProgress: Bool
    @Binding var timeStyle: Text.DateStyle

    var body: some View {
        LazyVStack {
            ForEach(sessions) { (session: Session) in
                VStack {
                    if session.isSameDay == false {
                        Group {
                            if session.pageStart != 0 {
                                Divider()
                            }
                            HStack {
                                Text(dayFormatter.string(from: session.createdAt))
                                    .font(.headline)
                                + Text(" ")
                                + Text(calendarDateFormatter.string(from: session.createdAt))
                                    .foregroundColor(.gray)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 5)
                    }
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

                        // TODO: add "on" for .time
                        // add "at" for .relative
                        Text(session.createdAt, style: timeStyle)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .onTapGesture {
                                timeStyle = timeStyle == .time ? .relative : .time
                            }

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
