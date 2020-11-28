//
//  SessionListBook.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-10-07.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI
//    @Binding var editMode: EditMode
//
//    var conditionalSessionCreateField: some View {
//        switch editMode {
//        case .active: return AnyView(
//            SessionCreateField(viewModel: viewModel.sessionCreateFieldViewModel)
//        )
//        default: return AnyView(EmptyView())
//        }
//    }
//            conditionalSessionCreateField

struct SessionListBook: View, ViewModelObserver {
    @StateObject var viewModel: SessionListBookViewModel

    init(sessions: [Session], editModePublisher: Published<EditMode>.Publisher) {
        self._viewModel = StateObject(
            wrappedValue: SessionListBookViewModel(sessions: sessions, editModePublisher: editModePublisher)
        )
    }

    var body: some View {
        Group {
            ForEach(viewModel.sections, id: \.key) { dateHeader, rowViewModels in
                Section(header: Text(dateHeader)) {
                    ForEach(rowViewModels) { rowViewModel in
                        SessionRow(viewModel: rowViewModel)
                    }
                }
            }
        }
    }
}

// struct SessionListBook_Previews: PreviewProvider {
//    static var previews: some View {
//        let book = BookSeeder.preview.fetch(bookWith: .sessions)
//        let sessionsPublisher = book.publisher(for: \.sessions).eraseToAnyPublisher()
//        let viewModel = SessionListBookViewModel(sessions: book.sessions, sessionsPublisher: sessionsPublisher)
//
//        return Group {
//            List {
//                SessionListBook(viewModel: viewModel)
//            }
//            .listStyle(InsetGroupedListStyle())
//
//            NavigationView {
//                List {
//                    SessionListBook(viewModel: viewModel)
//                }
//                .listStyle(InsetGroupedListStyle())
//            }
//        }
//        .previewDevice("iPhone SE (2nd generation)")
//    }
// }
