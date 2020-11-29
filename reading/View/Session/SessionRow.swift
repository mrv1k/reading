//
//  SessionRow.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-10-07.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}

struct SessionRow: View, ViewModelObserver {
    @ObservedObject var viewModel: SessionRowViewModel
//    @Environment(\.editMode) var editMode

    @State var progressTextEdit = false
    @State var stub = ""

    // FIXME: currently becasue of any view the whole list is being rerendered
    var text: AnyView {
        Text(viewModel.progress)
            .onLongPressGesture {
//                editMode?.wrappedValue = .active
                progressTextEdit = true
            }
            .eraseToAnyView()
    }

//    var editModeActive: Bool {
//        guard let editMode = editMode?.wrappedValue else { return false }
//        return editMode == .active
//    }

//    var textOrTextField: some View {
//        if editModeActive && progressTextEdit {
//            print(editModeActive, progressTextEdit)
//            return TextField(viewModel.progress, text: $stub).eraseToAnyView()
//        } else {
//            print("esle", viewModel.progress)
//            return text
//        }
//    }

    var body: some View {
        HStack {
            text
            Spacer()
            Text(viewModel.time).font(.caption).foregroundColor(.gray)
        }
    }
}

//struct SessionRow_Previews: PreviewProvider {
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
//}
