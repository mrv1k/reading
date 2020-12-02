//
//  SessionRow.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-10-07.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Introspect
import SwiftUI

struct SessionRow: View, ViewModelObserver {
    @ObservedObject var viewModel: SessionRowViewModel

    var textField: some View {
        TextField(
            viewModel.progressPlaceholder,
            text: $viewModel.progressInput,
            onEditingChanged: viewModel.hideProgressTrailingTextOnEditing) {
                print("onCommit")
        }
//        .keyboardType(.numberPad)
    }

    @ViewBuilder var textField2: some View {
        if viewModel.isNewSession {
            textField
                .introspectTextField { $0.becomeFirstResponder() }
        } else {
            textField
        }
    }

    var body: some View {
        HStack {
            ZStack(alignment: .leading) {
                textField2

                HStack(spacing: 0) {
                    Text(viewModel.progressInput).hidden()
                    Text(viewModel.progressTrailingText).foregroundColor(.gray)
                }
                .opacity(viewModel.progressTrailingTextHidden ? 0 : 1)
            }

            Spacer()
            Text(viewModel.time).font(.caption).foregroundColor(.gray)
        }
    }
}

// struct SessionRow_Previews: PreviewProvider {
//    static var previews: some View {
//        let book = BookSeeder.preview.fetch(bookWith: .sessions)
//        let session = book.sessions.first!
//        let viewModel = SessionRowViewModel(
//            createdAt: session.createdAt,
//            progressPage: session.progressPage,
//            raw_progressPercent: session.raw_progressPercent
//        )
//
//        return Group {
//            SessionRow(viewModel: viewModel)
//
//            SessionRow(
//                viewModel: SessionRowViewModel(createdAt: Date(), progressPage: 13, raw_progressPercent: 130)
//            )
//        }.previewLayout(.sizeThatFits)
//    }
// }
