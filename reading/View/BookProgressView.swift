//
//  BookProgressView.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-10-22.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

struct BookProgressView: View {
    @Binding var value: Int
    var displayPercent = false

    private var percent: Double { Double(value) }

    var body: some View {
        if displayPercent {
            ProgressView(value: percent, total: 100)
            {}
            currentValueLabel: { Text("\(value)%") }
        } else {
            ProgressView(value: percent, total: 100)
        }
    }
}

struct BookProgressView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BookProgressView(value: .constant(33), displayPercent: true)
            BookProgressView(value: .constant(69))
            BookProgressView(value: .constant(100))
        }
        .previewLayout(.sizeThatFits)
    }
}
