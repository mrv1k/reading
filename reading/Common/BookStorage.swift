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

        let initSort = BookSort.tryLoadSaved()

        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        fetchRequest.sortDescriptors = [initSort.computedStruct.descriptor]

        booksController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: viewContext,
            sectionNameKeyPath: nil, cacheName: nil)

        sort = initSort
        super.init()

        booksController.delegate = self
        performFetch()

        refreshFetcher = $sort
            .dropFirst()
            .sink(receiveValue: { newSort in
                // FIXME: 2020-11-13 00:39:04.072927-0500 reading[4645:1067724] [UILog] Called -[UIContextMenuInteraction updateVisibleMenuWithBlock:] while no context menu is visible. This won't do anything.

                // shouldn't work but does ;)
                // FIXME: works only because of structs init from UserDefaults
                var temp = newSort.computedStruct
                print(temp.labelName, temp.ascendingValue)
                if self.sort == newSort {
                    temp.ascendingValue.toggle()
                }
                self.refreshFetchWith(descriptor: temp.descriptor)
                temp.save()
            })
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
