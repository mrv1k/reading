//
//  SessionCreatePagesSection.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-09-08.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

class SessionCreatePagesViewModel: ObservableObject {
    @Published var startField: String = "" {
        didSet { setProgressField() }
    }
    @Published var endField: String = "" {
        didSet { setProgressField() }
    }
    @Published var progressField: String = ""

    var start: Int { Int(startField) ?? 0 }
    var end: Int { Int(endField) ?? 0 }
    var fieldsInputIsValid: Bool { start > 0 && end > start }
    var progress: Int {
        fieldsInputIsValid ? end - start : 0
    }

    var progressFieldComputed: String {
        fieldsInputIsValid ? String(progress) : ""
    }
    func setProgressField() {
        progressField = progressFieldComputed
    }
}


struct SessionCreatePagesSection: View {
    @ObservedObject var viewModel: SessionCreatePagesViewModel

    var body: some View {
        Section(header: Text("Pages")) {
            TextField("Start", text: $viewModel.startField)
                .keyboardType(.numberPad)

            TextField("End", text: $viewModel.endField)
                .keyboardType(.numberPad)

            TextField("Read", text: $viewModel.progressField)
                .keyboardType(.numberPad)
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
