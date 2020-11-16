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

fileprivate func loadSavedSort() -> BookSortEnum? {
    if let savedSort = UserDefaults.standard.string(forKey: UserDefaultsKey.bookSort.rawValue) {
        return BookSortEnum.init(rawValue: savedSort)
    }
    return nil
}

class BookStorage: NSObject, ObservableObject {
    @Published var books: [Book] = []
    private let booksController: NSFetchedResultsController<Book>
    var bookListSortPickerViewModel: BookListSortPickerViewModel?
    var sort: BookSortProtocol
    var test: AnyCancellable?

    init(viewContext: NSManagedObjectContext) {

        let initSortSelector = loadSavedSort() ?? .title
        sort = BookSort.shared.makeStruct(sortSelector: initSortSelector)

        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        fetchRequest.sortDescriptors = [sort.descriptor]
        booksController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: viewContext,
            sectionNameKeyPath: nil, cacheName: nil)

        super.init()

        bookListSortPickerViewModel = BookListSortPickerViewModel(initSelector: initSortSelector)
        test = bookListSortPickerViewModel?.actionPublisher
            .sink(receiveValue: { action in
                print("mek", action)
                print(self.sort.labelName, self.sort.ascendingValue)
                switch action {
                case .changeSort:
                    break
//                    self.sort = BookSort.makeStruct(sortSelector: <#T##BookSortEnum#>)
                case .toggleDirection:
                    self.sort.ascendingValue.toggle()
                    print(self.sort.labelName, self.sort.ascendingValue)
                }

                self.refreshFetchWith(descriptor: self.sort.descriptor)
            })

        booksController.delegate = self
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
