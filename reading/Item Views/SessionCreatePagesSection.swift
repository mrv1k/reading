//
//  SessionCreatePagesSection.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-09-08.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

class SessionCreatePagesViewModel: ObservableObject {
    @Published var startField: String = ""
    @Published var endField: String = ""
    @Published var progressField: String = ""

    var pageStart: Int {
        return Int(startField) ?? 0
    }
    var pageEnd: Int {
        Int(endField) ?? 0
    }
    var pagesDifference: Int {
        if pageEnd == 0 || pageStart == 0 {
            return 0
        }
        return pageEnd - pageStart
    }
    var pagesProgress: String {
        !(startField.isEmpty && endField.isEmpty) ? String(pagesDifference) : ""
    }
}


struct SessionCreatePagesSection: View {
    @ObservedObject var viewModel: SessionCreatePagesViewModel

    var body: some View {
        Form {
            Section(header: Text("Pages")) {
                TextField("Start", text: $viewModel.startField)
                    .keyboardType(.numberPad)

                TextField("End", text: $viewModel.endField)
                    .keyboardType(.numberPad)
                
                TextField("Read", text: $viewModel.progressField)
                    .keyboardType(.numberPad)
            }

            Text("\(viewModel.pagesDifference)")
            Text(viewModel.pagesProgress)

            Button("Log") {
                print("\(viewModel)")
            }
        }
    }
}

struct SessionCreatePagesSection_Previews: PreviewProvider {
    static var previews: some View {
        SessionCreatePagesSection(viewModel: SessionCreatePagesViewModel())
    }
}
