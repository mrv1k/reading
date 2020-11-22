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
    @EnvironmentObject var settings: AppSettings

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

        return SessionRow(viewModel: SessionRowViewModel(session: session))
            .previewLayout(.sizeThatFits)
    }
}
