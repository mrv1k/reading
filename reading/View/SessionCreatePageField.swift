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
    var placeholder: String

    var body: some View {
        HStack {
            TextField(placeholder, text: $fieldViewModel.fieldInput)
                .frame(maxHeight: .infinity)
                .keyboardType(.numberPad)

            Text(fieldViewModel.validationMessage)

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

// struct SessionCreatePageField_Previews: PreviewProvider {
//     static var previews: some View {
//         SessionCreatePageField(fieldViewModel: SessionCreatePageViewModel())
//     }
// }
