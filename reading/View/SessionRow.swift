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
        Text("SessionRow")
    }
}

struct SessionRow_Previews: PreviewProvider {
    static var previews: some View {
        let book = BookSeeder.preview.fetch(bookWith: .sessions)

        return SessionRow(session: book.sessions.first!)
            .previewDevice("iPhone SE (2nd generation)")
    }
}
