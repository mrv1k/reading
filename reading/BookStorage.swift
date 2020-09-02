//
//  BookStorage.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-09-02.
//  Copyright © 2020 mrv1k. All rights reserved.
//  based on: https://www.donnywals.com/fetching-objects-from-core-data-in-a-swiftui-proje
//

import Foundation
import Combine
import CoreData

class BookStorage: NSObject, ObservableObject {
    @Published var books: [Book] = []
    @Published var sortDescriptor: NSSortDescriptor

    private let booksController: NSFetchedResultsController<Book>

    init(viewContext: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()

        let descriptor = savedSortDescriptor() ?? Book.sortByTitle
        sortDescriptor = descriptor
        fetchRequest.sortDescriptors = [descriptor]

        booksController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: viewContext,
            sectionNameKeyPath: nil, cacheName: nil)

        super.init()

        booksController.delegate = self

        performFetch()
    }

    func performFetch() {
        do {
            try booksController.performFetch()
            books = booksController.fetchedObjects ?? []
        } catch {
            print("failed to fetch books")
        }
    }

    func performSortedFetch() {
        booksController.fetchRequest.sortDescriptors = [sortDescriptor]
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

fileprivate func savedSortDescriptor() -> NSSortDescriptor? {
    if let saved = UserDefaults.standard.object(forKey: "sortDescriptor") as? Data {
        if let decoded = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(saved) as? NSSortDescriptor {
            return decoded
        }
    }
    return nil
}
