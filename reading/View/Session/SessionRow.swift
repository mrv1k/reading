//
//  SessionRow.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-10-07.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

class SessionRowViewModel: ObservableObject {
    var weekDay: String
    var monthDay: String

    init(session: Session) {
        weekDay = Helpers.dateFormatters.day.string(from: session.createdAt)
        monthDay = Helpers.dateFormatters.month.string(from: session.createdAt)
    }
}

struct SessionRow: View {
    var session: Session
    @StateObject var viewModel: SessionRowViewModel

    init(session: Session) {
        self.session = session

        _viewModel = StateObject(wrappedValue: SessionRowViewModel(session: session))
    }

    var body: some View {
        VStack {
            if session.reverse_showDayLabel {
                dateHeader
            }
            HStack {
                Text("\(session.progressPage)")

                Spacer()
            }
        }
        .padding(.top, 1)
    }

    var dateHeader: some View {
        Group {
            Divider()
            HStack {
                Text(Helpers.dateFormatters.day.string(from: session.createdAt)).font(.headline)
                    + Text(" ")
                    + Text(Helpers.dateFormatters.month.string(from: session.createdAt)).foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct SessionRow_Previews: PreviewProvider {
    static var previews: some View {
        let book = BookSeeder.preview.fetch(bookWith: .sessions)

        return SessionRow(session: book.sessions.first!)
            .previewLayout(.sizeThatFits)
    }
}
