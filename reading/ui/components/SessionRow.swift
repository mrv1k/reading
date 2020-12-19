//
//  SessionRow.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-10-07.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

struct DomainSession: Equatable {
    var percent: String = "69"
    var page: String = "33"
    var recordedTime: String = "10:13 PM"
}

enum SessionProgress {
    case pages
    case percents
}

struct SessionRow: View {
    let session = DomainSession()
    var displayProgress: SessionProgress = .pages

    var progress: some View {
        switch displayProgress {
        case .pages: return pages
        case .percents: return percents
        }
    }

    var pages: Text { Text(session.page) + Text(" pages").foregroundColor(.gray) }
    var percents: Text { Text(session.percent) + Text("%").foregroundColor(.gray) }

    var body: some View {
        HStack(spacing: 0) {
            progress

            Spacer()
            Text(session.recordedTime).font(.caption).foregroundColor(.gray)
        }
    }
}

struct SessionRow_Previews: PreviewProvider {
//    [31, 60, 83, 90]
    let sessions = [
        "Today": DomainSession(),
        "December 16": DomainSession(),
        "December 15": DomainSession(),
        "December 14": DomainSession()
    ]

    static var previews: some View {
        return Group {
            Group {
                SessionRow()
                SessionRow(displayProgress: .percents)
            }
            .previewLayout(.sizeThatFits)

            Group {
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

                List {
                    Section(header: Text("Today")) {
                        SessionRow(displayProgress: .percents)
                    }
                    Section(header: Text("December 16")) {
                        SessionRow(displayProgress: .percents)
                    }
                    Section(header: Text("December 15")) {
                        SessionRow(displayProgress: .percents)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .previewDevice("iPhone SE (2nd generation)")
        }
    }
}
