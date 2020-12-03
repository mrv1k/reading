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
    @Environment(\.editMode) var editMode
    @ObservedObject var viewModel: SessionRowViewModel

    var editModeValue: EditMode { editMode?.wrappedValue ?? .inactive }

    var body: some View {
        HStack {
            ZStack(alignment: .leading) {
                TextField(
                    viewModel.progressPlaceholder,
                    text: $viewModel.progressInput)
                    .disabled(editModeValue == .inactive && !viewModel.isNewSession)
                    .ifConditional(viewModel.isNewSession) { textField in
                        textField.introspectTextField { $0.becomeFirstResponder() }
                    }

                HStack(spacing: 0) {
                    Text(viewModel.progressInput).hidden()
                    Text(viewModel.progressTrailingText).foregroundColor(.gray)
                        .opacity(editModeValue == .inactive ? 1 : 0)
                }
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
