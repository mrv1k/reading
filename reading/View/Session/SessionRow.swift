//
//  SessionRow.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-10-07.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

struct SessionRow: View, ViewModelObserver {
    @ObservedObject var viewModel: SessionRowViewModel

    var body: some View {
        HStack(spacing: 0) {
            Text(viewModel.progress)
            Text(viewModel.progressTrailingText).foregroundColor(.gray)

            Spacer()
            Text(viewModel.time).font(.caption).foregroundColor(.gray)
        }
    }
}

struct SessionRow_Previews: PreviewProvider {
    static var previews: some View {
        let book = BookSeeder.preview.fetch(bookWith: .sessions)
        let session = book.sessions.first!
        let viewModel = SessionRowViewModel(session: session)

        return Group {
            SessionRow(viewModel: viewModel)

//            SessionRow(
//                viewModel: SessionRowViewModel(createdAt: Date(), progressPage: 13, raw_progressPercent: 130)
//            )
        }.previewLayout(.sizeThatFits)
    }
}
