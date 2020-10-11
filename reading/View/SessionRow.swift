//
//  SessionRow.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-10-07.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

struct SessionRow: View {
    var session: Session

    var body: some View {
        VStack(alignment: .leading) {
            Text("Start \(session.pageStart)")
            Text("End \(session.pageEnd)")
            Text("Page Progress  \(session.progressPage)")
            Text("Percent Progress \(session.progressPage)%")
        }
    }
}

struct SessionRow_Previews: PreviewProvider {
    static var previews: some View {
        let book = BookSeeder.preview.fetch(bookWith: .test)

        return SessionRow(session: book.sessionsArray.first!)
            .previewDevice("iPhone SE (2nd generation)")
    }
}
