//
//  AppSettings.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-11-10.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Combine
import Foundation

protocol AppSettingsViewModel: ObservableObject {
    static var singleton: AppSettings { get }
}

protocol AppSettingsObserver {
    var settings: AppSettings { get }
}

extension AppSettingsObserver {
    var settings: AppSettings { AppSettings.singleton }
}

class AppSettings: AppSettingsViewModel {
    static var singleton = AppSettings()

    @Published var progressPercentage: Bool
    private var cancellables = Set<AnyCancellable>()

    private init() {
        progressPercentage = UserDefaults.standard.bool(forKey: UserDefaultsKey.progressPercentage.rawValue)

        subscribeToSaveInUserDefaults(publisher: $progressPercentage, key: .progressPercentage)
    }

    func subscribeToSaveInUserDefaults<T>(publisher: Published<T>.Publisher, key: UserDefaultsKey) {
        publisher
            .dropFirst()
            .sink { UserDefaults.standard.set($0, forKey: key.rawValue) }
            .store(in: &cancellables)
    }
}
