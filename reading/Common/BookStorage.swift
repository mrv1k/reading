//
//  BookStorage.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-09-02.
//  Copyright © 2020 mrv1k. All rights reserved.
//  inspired by: https://www.donnywals.com/fetching-objects-from-core-data-in-a-swiftui-proje
//

import Combine
import CoreData
import Foundation

class BookStorage: NSObject, ObservableObject {
    @Published var books = [Book]()
    private let booksController: NSFetchedResultsController<Book>

    private var sort = InitialBookSort.sort
    @Published var sortSelection = InitialBookSort.sort.selection
    @Published var directionImage = InitialBookSort.sort.directionImage
    private var cancellables = Set<AnyCancellable>()

    init(viewContext: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        fetchRequest.sortDescriptors = [sort.descriptor]
        booksController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: viewContext,
            sectionNameKeyPath: nil, cacheName: nil)
        super.init()

        booksController.delegate = self
        performFetch()

        menuSelectionHandler.store(in: &cancellables)
    }

    var menuSelectionHandler: AnyCancellable {
        $sortSelection
            .dropFirst()
            .map { selection -> BookSort in
                // if current and new sort are the same, toggle sort direction
                if self.sortSelection == selection {
                    self.sort.isAscending.toggle()
                } else {
                    self.sort = BookSortFactory.create(selection: selection)
                }
                return self.sort
            }
            .sink(receiveValue: { sort in
                self.refreshFetchWith(descriptor: sort.descriptor)
                self.directionImage = sort.directionImage
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
