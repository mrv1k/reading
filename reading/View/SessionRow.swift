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
            if viewModel.model.isSameDay == false {
                Group {
                    if viewModel.model.pageStart != 0 {
                        Divider()
                    }
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
                        Text("\(viewModel.model.progressPage) pages")
                    } else {
                        Text("\(viewModel.model.progressPercent)%")
                    }
                }
                .onTapGesture { listViewModel.togglePageProgressStyle() }

                Spacer()

                // TODO: add "on" for .time
                // add "at" for .relative
                // Text(sessionViewModel.model.createdAt, style: timeStyle)
                //     .font(.subheadline)
                //     .foregroundColor(.gray)
                //     .onTapGesture {
                //         timeStyle = timeStyle == .time ? .relative : .time
                //     }
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
            listViewModel: SessionListBookViewModel(session: book.sessions)
        )
        .previewLayout(.sizeThatFits)
    }
}
