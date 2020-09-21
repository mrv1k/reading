//
//  SessionCreatePagesSection.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-09-08.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

struct SessionCreatePagesSection: View {
    @ObservedObject var sectionViewModel: SessionCreatePagesViewModel

    @State var validationAlert = false

    var body: some View {
        Section(footer: Text("start validation: " + sectionViewModel.sectionValidation).foregroundColor(.red)) {
            SessionCreatePageField(
                fieldViewModel: sectionViewModel.startViewModel,
                placeholder: "Start page")

            SessionCreatePageField(
                fieldViewModel: sectionViewModel.endViewModel,
                placeholder: "End page")

            SessionCreatePageField(
                fieldViewModel: sectionViewModel.progressViewModel,
                placeholder: "Progressed pages")
        }
    }
}

struct SessionCreatePagesSection_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            SessionCreatePagesSection(sectionViewModel: SessionCreatePagesViewModel())
        }
    }
}
