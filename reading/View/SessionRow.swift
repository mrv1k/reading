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
    @ObservedObject var listViewModel: SessionListBookViewModel

    var body: some View {
        VStack {
            if viewModel.reverse_showDayLabel {
                Group {
                    Divider()
                    HStack {
                        Text(viewModel.weekDay).font(.headline) +
                        Text(" ") +
                        Text(viewModel.monthDate).foregroundColor(.gray)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            HStack {
                Group {
                    if listViewModel.pageProgressStyle == .page {
                        Text(viewModel.progressPage)
                    } else {
                        Text(viewModel.progressPercent)
                    }
                }
                .onTapGesture(perform: listViewModel.togglePageProgressStyle)

                Spacer()

                Group {
                    Text(listViewModel.timePrefix) +
                    Text(viewModel.session.createdAt, style: listViewModel.timeStyle) +
                    Text(listViewModel.timeSuffix)
                }
                .font(.subheadline)
                .foregroundColor(.gray)
                .onTapGesture(perform: listViewModel.toggleTimeStyle)
            }
        }
        .padding(.top, 1)
    }
}

struct SessionRow_Previews: PreviewProvider {
    static var previews: some View {
        let book = BookSeeder.preview.fetch(bookWith: .sessions)

        return SessionRow(
            viewModel: .init(session: book.sessions.first!),
            listViewModel: SessionListBookViewModel(book: book)
        )
        .previewLayout(.sizeThatFits)
    }
}
