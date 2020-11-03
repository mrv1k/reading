//
//  SessionRow.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-10-07.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

struct SessionRow: View {
    var session: Session

    var body: some View {
        VStack {
            if session.reverse_showDayLabel {
                Group {
                    Divider()
                    HStack {
                        Text(DateFormatterHelper.shared.day.string(from: session.createdAt))
                        + Text(DateFormatterHelper.shared.month.string(from: session.createdAt))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            HStack {
                Group {
                    Text("\(session.progressPage)")
                }

                Spacer()
            }
        }
        .padding(.top, 1)
    }
}

// struct SessionRow_Previews: PreviewProvider {
//     static var previews: some View {
//         let book = BookSeeder.preview.fetch(bookWith: .sessions)
//
//         return SessionRow(
//             viewModel: .init(session: book.sessions.first!),
//             listViewModel: SessionListBookViewModel(book: book)
//         )
//         .previewLayout(.sizeThatFits)
//     }
// }
