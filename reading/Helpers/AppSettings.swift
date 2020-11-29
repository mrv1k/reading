//
//  AppSettings.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-11-10.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Combine
import Foundation

private protocol AppSettingsViewModel: ObservableObject {
    static var singleton: AppSettings { get }
}

protocol AppSettingsObserver {
    var settings: AppSettings { get }
}

// FIXME: rewrite so it publishes updates
extension AppSettingsObserver {
    var settings: AppSettings { AppSettings.singleton }
}

class AppSettings: AppSettingsViewModel {
    static var singleton = AppSettings()

    @Published var progressPercentage: Bool
    @Published var sessionsIsSortingByNewest: Bool
    private var cancellables = Set<AnyCancellable>()

    private init() {
        progressPercentage = UserDefaults.standard.bool(forKey: UserDefaultsKey.progressPercentage.rawValue)
        sessionsIsSortingByNewest = UserDefaults.standard.bool(forKey: UserDefaultsKey.sessionsIsSortingByNewest.rawValue)

        subscribeToSaveInUserDefaults(publisher: $progressPercentage, key: .progressPercentage)
            .store(in: &cancellables)
        subscribeToSaveInUserDefaults(publisher: $sessionsIsSortingByNewest, key: .sessionsIsSortingByNewest)
            .store(in: &cancellables)
    }

    private func subscribeToSaveInUserDefaults<T>(publisher: Published<T>.Publisher, key: UserDefaultsKey) -> AnyCancellable {
        publisher
            .dropFirst()
            .sink { UserDefaults.standard.set($0, forKey: key.rawValue) }
    }
}
