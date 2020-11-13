//
//  BookStorage.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-09-02.
//  Copyright © 2020 mrv1k. All rights reserved.
//  inspired by: https://www.donnywals.com/fetching-objects-from-core-data-in-a-swiftui-proje
//

import Foundation
import Combine
import CoreData

class BookStorage: NSObject, ObservableObject {
    @Published var books: [Book] = []
    @Published var sort: BookSort

    private let booksController: NSFetchedResultsController<Book>
    private var refreshFetcher: AnyCancellable?

    init(viewContext: NSManagedObjectContext) {

        let savedSort = UserDefaults.standard.string(forKey: UserKeys.bookSort.rawValue)
        // Has to use BookSort.init(rawValue:) or IDE wants to both add and remove force unwrap
        let initSort = (savedSort != nil) ? BookSort.init(rawValue: savedSort!)! : BookSort.title

        let initSortAscending = UserDefaults.standard.bool(forKey: UserKeys.getAscending(forSort: initSort))
        print(initSort, initSortAscending)

        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        fetchRequest.sortDescriptors = [initSort.descriptor(ascending: initSortAscending)]

        booksController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: viewContext,
            sectionNameKeyPath: nil, cacheName: nil)

        sort = initSort
        super.init()

        booksController.delegate = self

        refreshFetcher = $sort
            .dropFirst()
            .sink(receiveValue: { sort in
                let ascendingKey = UserKeys.getAscending(forSort: sort)
                var sortAscending = UserDefaults.standard.bool(forKey: ascendingKey)
                print(ascendingKey, sortAscending)

                if self.sort == sort {
                    sortAscending = !sortAscending
                }
                self.refreshFetchWith(descriptor: sort.descriptor(ascending: sortAscending))

                UserDefaults.standard.set(sort.rawValue, forKey: UserKeys.bookSort.rawValue)
                UserDefaults.standard.set(sortAscending, forKey: ascendingKey)
            })

        performFetch()
    }

    private func performFetch() {
        do {
            try booksController.performFetch()
            books = booksController.fetchedObjects ?? []
        } catch {
            print(#function, "failed")
        }
    }

    private func refreshFetchWith(descriptor: NSSortDescriptor) {
        booksController.fetchRequest.sortDescriptors = [descriptor]
        performFetch()
    }
}

extension BookStorage: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let refetchedBooks = controller.fetchedObjects as? [Book]
        else { return }
        books = refetchedBooks
    }
}
