//
//  AppToolbar.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-11-22.
//  Copyright © 2020 mrv1k. All rights reserved.
//
// Other SF icons I like:
// lightbulb 􀛭􀛮 | scroll 􀤏􀤐         | eyeglasses 􀖆
// gauge 􀍽       | gauge.badge.plus 􀓓 | gauge.badge.minus 􀓧
//

import SwiftUI

struct AppToolbar: ToolbarContent {
    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .bottomBar) {
            ToolbarButton(action: {}, text: "Reading Now", icon: "scroll")
            Spacer()
            ToolbarButton(action: {}, text: "Library", icon: "books.vertical")
            Spacer()
            ToolbarButton(action: {}, text: "Statistics", icon: "gauge")
            Spacer()
            ToolbarButton(action: {}, text: "Settings", icon: "gearshape")
        }
    }
}

extension AppToolbar {
    struct ToolbarButton: View {
        var action: () -> Void
        var text: String
        var icon: String

        var body: some View {
            Button(action: action, label: {
                VStack {
                    Image(systemName: icon)
                    Text(text).font(.caption2).bold()
                }
            })
        }
    }
}

struct ToolbarButton_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Text("stub")
                .toolbar { AppToolbar() }
        }.previewDevice("iPhone SE (2nd generation)")
    }
}
