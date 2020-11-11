//
//  AppSettings.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-11-10.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

protocol AppSettingsProvider {
    static var shared: AppSettings { get set }
}

protocol AppSettingsConsumer {
    var settings: AppSettings { get }
}

extension AppSettingsConsumer {
    var settings: AppSettings { AppSettings.shared }
}

class AppSettings: ObservableObject, AppSettingsProvider {
    static var shared = AppSettings()

    private init() {}

    // TODO: make persistent
    @Published var progressStyle = SessionStyleProgress.page
    @Published var timeStyle = SessionStyleTime.time
}

enum SessionStyleProgress: String, CaseIterable {
    case page
    case percent
}

enum SessionStyleTime: String, CaseIterable {
    case time
    case relative

    var type: Text.DateStyle {
        switch self {
        case .time: return Text.DateStyle.time
        case .relative: return Text.DateStyle.relative
        }
    }
}
