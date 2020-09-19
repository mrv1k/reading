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
    // @StateObject var startViewModel = SessionCreatePageViewModel()
    // @StateObject var endViewModel = SessionCreatePageViewModel()
    // @StateObject var progressViewModel = SessionCreatePageViewModel()


    @State var validationAlert = false

    var body: some View {
        Section(footer: Text("Hey, that's not okay").foregroundColor(.red)) {
            SessionCreatePageField(fieldViewModel: viewModel.startViewModel, placeholder: "Start page")

            // FIXME: doesn't update because startViewModel is not ObservedObjet in this view
            Text(viewModel.startViewModel.validationMessage)

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

            if viewModel.startValidation.count != 0 {
                VStack {
                    ForEach(viewModel.startValidation, id: \.self) { msg in
                        Text(msg)
                            .foregroundColor(.red)
                            .font(.callout)
                    }
                }
            }
            if viewModel.endValidation.count != 0 {
                VStack {
                    ForEach(viewModel.endValidation, id: \.self) { msg in
                        Text(msg)
                            .foregroundColor(.red)
                            .font(.callout)
                    }
                }
            }
            if viewModel.progressValidation.count != 0 {
                VStack {
                    ForEach(viewModel.progressValidation, id: \.self) { msg in
                        Text(msg)
                            .foregroundColor(.red)
                            .font(.callout)
                    }
                }
            }

            Button("Reset") {
                viewModel.startField = ""
                viewModel.endField = ""
                viewModel.progressField = ""
            }

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
