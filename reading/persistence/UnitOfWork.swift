//
//  UnitOfWork.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-12-15.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Foundation
import CoreData

class UnitOfWork: ObservableObject {
    let repository: DomainBookRepository
    var cdBookStorage: CDBookStorage
    @Published var domainBooks = [DomainBook]()

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
        repository = DomainBookRepository(context: context)
        cdBookStorage = CDBookStorage(viewContext: context)

        cdBookStorage.$cdBooks
            .map { cdBooks in cdBooks.map { cdBook in cdBook.toDomainModel() } }
            .assign(to: &$domainBooks)
    }
}
