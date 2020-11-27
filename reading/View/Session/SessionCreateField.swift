//
//  SessionCreateField.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-11-19.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Introspect
import SwiftUI

struct SessionCreateField: View, ViewModelObserver {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var viewModel: SessionCreateFieldViewModel

    @State private var becomeFirstResponderProxy = {}

    var body: some View {
//        HStack {
//             TODO: a setting to toggle between page (default) and percent input
        TextField(viewModel.pageEndPlaceholder, text: $viewModel.pageEndInput)
            .keyboardType(.numberPad)
            .introspectTextField { textField in
                becomeFirstResponderProxy = { textField.becomeFirstResponder() }
                becomeFirstResponderProxy()
            }
            .onAppear { becomeFirstResponderProxy() }

        // FIXME: rewrite to  use EditButton done to save
//            Button {
//                viewModel.save(context: viewContext)
//            } label: {
//                Image(systemName: "plus.circle.fill").imageScale(.large)
//            }
//            .buttonStyle(PlainButtonStyle())
//            .padding(.leading)
//        }
    }
}

struct SessionCreateField_Previews: PreviewProvider {
    static var previews: some View {
        let book = BookSeeder.preview.fetch(bookWith: .sessions)
        let viewModel = SessionCreateFieldViewModel(book: book)

        SessionCreateField(viewModel: viewModel)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .previewLayout(.sizeThatFits)
    }
}
