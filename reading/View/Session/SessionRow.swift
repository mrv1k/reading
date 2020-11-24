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
        VStack {
            if viewModel.showDayLabelForReverseArray {
                Divider()
                Text(viewModel.date)
                    .font(.footnote)
                    .foregroundColor(.gray)
            }

            HStack {
                Text(viewModel.progress)
                Spacer()
                Text(viewModel.time)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct SessionRow_Previews: PreviewProvider {
    static var previews: some View {
        let book = BookSeeder.preview.fetch(bookWith: .sessions)
        let session = book.sessions.first!
        let viewModel = SessionRowViewModel(
            createdAt: session.createdAt,
            progressPage: session.progressPage,
            raw_progressPercent: session.raw_progressPercent,
            reverse_showDayLabelPublisher: session.publisher(for: \.reverse_showDayLabel).eraseToAnyPublisher())

        return SessionRow(viewModel: viewModel)
            .previewLayout(.sizeThatFits)
    }
}
