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
    var width: CGFloat

    var body: some View {
        HStack(spacing: 0) {
            Text("\(session.pageStart)")
                .frame(width: width)
            Text("\(session.pageEnd)")
                .frame(width: width)
            Text("\(session.progressPage)")
                .frame(width: width)
            Text("\(session.progressPage)%")
                .frame(width: width)
        }
    }
}

struct SessionRow_Previews: PreviewProvider {
    static var previews: some View {
        let book = BookSeeder.preview.fetch(bookWith: .test)

        return GeometryReader { container in
            SessionRow(
                session: book.sessionsArray.first!,
                width: container.size.width / 4)
        }
        .previewDevice("iPhone SE (2nd generation)")
    }
}
