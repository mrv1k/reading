//
//  SessionRow.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-10-07.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Introspect
import SwiftUI

// https://forums.swift.org/t/conditionally-apply-modifier-in-swiftui/32815/17
extension View {
    @ViewBuilder func ifConditional<T>(_ condition: Bool, transform: (Self) -> T) -> some View where T: View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

struct SessionRow: View, ViewModelObserver {
    @ObservedObject var viewModel: SessionRowViewModel

    var body: some View {
        HStack {
            ZStack(alignment: .leading) {
                TextField(
                    viewModel.progressPlaceholder,
                    text: $viewModel.progressInput,
                    onEditingChanged: viewModel.hideProgressTrailingTextOnEditing) {
                    print("onCommit")
                }
                .ifConditional(viewModel.isNewSession) { textField in
                    textField.introspectTextField { textField in textField.becomeFirstResponder() }
                }

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
