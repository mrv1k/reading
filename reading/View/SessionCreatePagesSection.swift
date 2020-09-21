//
//  SessionCreatePagesSection.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-09-08.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

struct SessionCreatePagesSection: View {
    @ObservedObject var viewModel: SessionCreatePagesViewModel

    @State var validationAlert = false

    var body: some View {
        Section(footer: Text(viewModel.sectionValidation).foregroundColor(.red)) {
            SessionCreatePageField(
                fieldViewModel: viewModel.startViewModel,
                placeholder: "Start page")


            // HStack {
            //     PageTextField(placeholder: "End page", text: $viewModel.endField)
            //     PageAutofillButton(canBeAutofilled: viewModel.canBeAutofilled(field: .end)) {
            //         viewModel.autofill(field: .end)
            //     }
            // }
            //
            // HStack {
            //     PageTextField(placeholder: "Progress", text: $viewModel.progressField)
            //     PageAutofillButton(canBeAutofilled: viewModel.canBeAutofilled(field: .progress)) {
            //         viewModel.autofill(field: .progress)
            //     }
            // }

            // Button("submit") {
            //     validationAlert.toggle()
            // }.alert(isPresented: $validationAlert) { () -> Alert in
            //     Alert(title: Text(startViewModel.validationMessage))
            // }

            // Button("Reset") {
            //     viewModel.startField = ""
            //     viewModel.endField = ""
            //     viewModel.progressField = ""
            // }

            // if !viewModel.validationMessages.isEmpty {
            //     Button("Submit") {
            //         print("invalid submit")
            //         validationAlert = true
            //     }
            //     .alert(isPresented: $validationAlert) {
            //         Alert(title: Text(viewModel.validationMessages.first!))
            //     }
            // } else {
            //     Button("Submit") {
            //         print("valid submit")
            //     }
            // }
        }
    }
}

struct SessionCreatePagesSection_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            SessionCreatePagesSection(viewModel: SessionCreatePagesViewModel())
        }
    }
}
