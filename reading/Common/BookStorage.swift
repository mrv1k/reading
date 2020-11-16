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
    @Published var sortSelection: BookSortMenuOption = InitialBookSort.shared.selection
    @Published var sortDirectionImage: String = InitialBookSort.shared.sort.labelImage

    private var sort: BookSortProtocol = InitialBookSort.shared.sort
    private var cancellableBag = Set<AnyCancellable>()
    private let booksController: NSFetchedResultsController<Book>

    init(viewContext: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        fetchRequest.sortDescriptors = [sort.descriptor]
        booksController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: viewContext,
            sectionNameKeyPath: nil, cacheName: nil)
        super.init()

        menuSelectionHandler.store(in: &cancellableBag)

        booksController.delegate = self
        performFetch()
    }

    var menuSelectionHandler: AnyCancellable {
        $sortSelection
            .dropFirst()
            .sink(receiveValue: { selection in
                // if current and new sort are the same, toggle sort direction
                if self.sortSelection == selection {
                    self.sort.ascendingValue.toggle()
                } else {
                    self.sort = BookSort.shared.makeStruct(sortSelector: selection)
                }

                self.sortDirectionImage = self.sort.labelImage
                self.refreshFetchWith(descriptor: self.sort.descriptor)
                BookSort.shared.save(sort: self.sort)
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

    func refreshFetchWith(descriptor: NSSortDescriptor) {
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
