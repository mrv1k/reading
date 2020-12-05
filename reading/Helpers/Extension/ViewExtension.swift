//
//  ViewExtension.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-12-04.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

// https://forums.swift.org/t/conditionally-apply-modifier-in-swiftui/32815/17
extension View {
    @ViewBuilder func ifConditional<T>(_ condition: Bool, transform: (Self) -> T) -> some View where T: View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
