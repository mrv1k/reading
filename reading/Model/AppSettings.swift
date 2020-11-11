//
//  AppSettings.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-11-10.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Combine

protocol AppSettingsProvider {
    static var shared: AppSettings { get set }
}

class AppSettings: ObservableObject, AppSettingsProvider {
    static var shared = AppSettings()

    private init() {}

    // TODO: make persistent
    @Published var progressStyle = SessionStyleProgress.page
    @Published var timeStyle = SessionStyleTime.time
}

enum SessionStyleProgress: String, CaseIterable {
    case page = "Pages"
    case percent = "Percents"
}

enum SessionStyleTime: String, CaseIterable {
    case time = "at 12:34"
    case relative = "3 min., 22 sec ago"
}


protocol AppSettingsConsumer {
    var settings: AppSettings { get }
}

extension AppSettingsConsumer {
    var settings: AppSettings { AppSettings.shared }
}
