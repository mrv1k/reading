//
//  SessionRow.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-10-07.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

struct SessionRow: View {
    @ObservedObject var viewModel: SessionRowViewModel
    @EnvironmentObject var settings: AppSettings

    var timeStyle: Text.DateStyle {
        settings.relativeTime ? .relative : .time
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

    var body: some View {
        VStack {
            if viewModel.showDayLabelForReverseArray {
                dateHeader
            }
            HStack {
                Text(viewModel.progress)

                Spacer()

                Group {
                    Text(viewModel.createdAt, style: timeStyle)
                }
                .font(.subheadline)
                .foregroundColor(.gray)
            }
        }
        .padding(.top, 1)
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
