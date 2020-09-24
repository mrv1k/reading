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
        TextField(
            placeholder,
            text: $fieldViewModel.input,
            onEditingChanged: fieldViewModel.onEditingChanged,
            onCommit: {}
        )
        .frame(maxHeight: .infinity)
        .keyboardType(.numberPad)
    }
}

struct SessionCreatePageField_Previews: PreviewProvider {
    static var previews: some View {
        SessionCreatePageField(fieldViewModel: SessionCreatePageViewModel(), placeholder: "placeholder")
    }
}
