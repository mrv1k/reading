//
//  UserData.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-08-30.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Foundation
import Combine

class UserData: ObservableObject {
    @Published var sortDescriptor: NSSortDescriptor = Book.sortByTitle

    init() {
        if let savedSortDescriptor = UserDefaults.standard.object(forKey: "sortDescriptor") as? Data {
            if let decodedSortDescriptor = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedSortDescriptor) as? NSSortDescriptor {
                sortDescriptor = decodedSortDescriptor
            }
        }
    }
}
