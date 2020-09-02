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
    private let booksController: NSFetchedResultsController<Book>

    init(viewContext: NSManagedObjectContext, sort: NSSortDescriptor) {
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        fetchRequest.sortDescriptors = [sort]

        booksController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: viewContext,
            sectionNameKeyPath: nil, cacheName: nil)

        super.init()

        booksController.delegate = self

        booksController.fetchRequest.sortDescriptors = [sort]
        do {
            try booksController.performFetch()
            books = booksController.fetchedObjects ?? []
            print("yup")
        } catch {
            print(#function, "failed to fetch books")
        }
    }

    func myPerformFetch(sort: NSSortDescriptor) {
        print(#function)
        booksController.fetchRequest.sortDescriptors = [sort]
        do {
            try booksController.performFetch()
            books = booksController.fetchedObjects ?? []
            print("yup")
        } catch {
            print(#function, "failed to fetch books")
        }
    }
}

extension BookStorage: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let refetchedBooks = controller.fetchedObjects as? [Book]
        else { return }
        books = refetchedBooks
    }
}
