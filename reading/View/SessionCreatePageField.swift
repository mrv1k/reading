//
//  SessionCreatePageField.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-09-19.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

struct SessionCreatePageField: View {
    @ObservedObject var fieldViewModel: SessionCreatePageViewModel

    var body: some View {
        HStack {
            TextField("Start page", text: $fieldViewModel.field)
                .frame(maxHeight: .infinity)
                .keyboardType(.numberPad)

            // if viewModel.canBeAutofilled(field: .start) {
            //     Divider()
            //     Button {
            //         viewModel.autofill(field: .start)
            //     } label: {
            //         Image(systemName: "text.badge.plus")
            //             .padding([.leading, .trailing])
            //     }
            //     .buttonStyle(BorderlessButtonStyle())
            // }
        }
    }
}

struct SessionCreatePageField_Previews: PreviewProvider {
    static var previews: some View {
        SessionCreatePageField(fieldViewModel: SessionCreatePageViewModel())
    }
}
