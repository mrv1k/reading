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
    @Environment(\.editMode) var editMode

    @State var progressTextEdit = false
    @State var stub = ""

    var text: some View {
        Text(viewModel.progress)
    }

    var textOrTextField: some View {
        guard let editMode = editMode?.wrappedValue else {
            return text.eraseToAnyView()
        }

        if editMode == .active && progressTextEdit {
            return TextField(viewModel.progress, text: $stub).eraseToAnyView()
        } else {
            return text
                .onLongPressGesture {
                    progressTextEdit.toggle()
                }
                .eraseToAnyView()
        }
    }

    var body: some View {
        HStack {
            textOrTextField
                .background(Color.green)
            Spacer()
            Text(viewModel.time).font(.caption).foregroundColor(.gray)
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
            raw_progressPercent: session.raw_progressPercent
        )

        return Group {
            SessionRow(viewModel: viewModel)

            SessionRow(
                viewModel: SessionRowViewModel(createdAt: Date(), progressPage: 13, raw_progressPercent: 130)
            )
        }.previewLayout(.sizeThatFits)
    }
}
