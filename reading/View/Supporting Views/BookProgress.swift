//
//  BookProgress.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-11-08.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

struct BookProgress: View {
    var progress: Double

    var showLabel = false
    var valueLabel: String { "\(progress)%" }

    var body: some View {
        if showLabel {
            ProgressView(value: progress, total: 100)
            {} // label: () -> _,
            currentValueLabel: { Text(valueLabel) }
        } else {
            ProgressView(value: progress, total: 100)
        }
    }
}

struct BookProgress_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BookProgress(progress: 69)

            BookProgress(progress: 69, showLabel: true)

        }.previewLayout(.sizeThatFits)
    }
}
