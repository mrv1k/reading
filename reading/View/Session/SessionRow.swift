//
//  SessionRow.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-10-07.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

// extension View {
//    func eraseToAnyView() -> AnyView {
//        AnyView(self)
//    }
// }

struct SessionRow: View, ViewModelObserver {
    @ObservedObject var viewModel: SessionRowViewModel
//    @Environment(\.editMode) var editMode

//    var editModeActive: Bool {
//        guard let editMode = editMode?.wrappedValue else { return false }
//        return editMode == .active
//    }

    var body: some View {
        HStack {
            VStack {
                Text(viewModel.progressText)
                TextField(
                    viewModel.progressText,
                    text: $viewModel.progressInput,
                    onCommit: {})
                    .keyboardType(.numberPad)
            }
            // .id?
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
