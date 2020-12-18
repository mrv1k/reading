//
//  SessionRow.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-10-07.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

struct DomainSession: Equatable, Identifiable {
    var id: UUID { persistenceID ?? UUID() }
    var persistenceID: UUID? = nil

    var percent: String = "10%"
    var page: String = "10"
    var recordedTime: String = Helpers.dateFormatters.time.string(from: Date())
//    time = Helpers.dateFormatters.time.string(from: session.createdAt)
}

struct SessionRow: View {
//    @ObservedObject var viewModel: SessionRowViewModel
    let session = DomainSession()

    var body: some View {
        HStack(spacing: 0) {
            Text(session.page)
            Text(" pages").foregroundColor(.gray)

            Spacer()
            Text(session.recordedTime).font(.caption).foregroundColor(.gray)
        }
    }
}

struct SessionRow_Previews: PreviewProvider {
    static var previews: some View {
//        let session = DomainSession()
//        createdAt: Date(), progressPage: 13, raw_progressPercent: 130
        return Group {
            SessionRow()
                .previewLayout(.sizeThatFits)

            List {
                Section(header: Text("Today")) {
                    SessionRow()
                }
                Section(header: Text("December 16")) {
                    SessionRow()
                }
                Section(header: Text("December 15")) {
                    SessionRow()
                }
            }
            .listStyle(InsetGroupedListStyle())
            .previewDevice("iPhone SE (2nd generation)")
        }
    }
}
