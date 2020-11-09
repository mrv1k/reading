//
//  SessionRow.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-10-07.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

class SessionRowViewModel: ObservableObject, Identifiable {
    private var session: Session

    init(session: Session) {
        self.session = session
    }

    var weekDay: String {
        Helpers.dateFormatters.day.string(from: session.createdAt)
    }

    var monthDay: String {
        Helpers.dateFormatters.month.string(from: session.createdAt)
    }

    var showDayLabelForReverseArray: Bool { session.reverse_showDayLabel }

    // var sessionProgress: String { TODO }

    var progressPage: String {
        "\(session.progressPage) \(session.progressPage == 1 ? "page" : "pages")"
    }
    var progressPercent: String {
        "\(Helpers.percentCalculator.rounded(session.raw_progressPercent))%"
    }
}

struct SessionRow: View {
    @ObservedObject var viewModel: SessionRowViewModel

    var body: some View {
        VStack {
            if viewModel.showDayLabelForReverseArray {
                dateHeader
            }
            HStack {
                Text(viewModel.progressPage)

                Spacer()
            }
        }
        .padding(.top, 1)
    }

    var dateHeader: some View {
        Group {
            Divider()
            HStack {
                Text(viewModel.weekDay).font(.headline)
                    + Text(" ")
                    + Text(viewModel.monthDay).foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct SessionRow_Previews: PreviewProvider {
    static var previews: some View {
        let book = BookSeeder.preview.fetch(bookWith: .sessions)
        let session = book.sessions.first!

        return SessionRow(viewModel: SessionRowViewModel(session: session))
            .previewLayout(.sizeThatFits)
    }
}
