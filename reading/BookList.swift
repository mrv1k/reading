import SwiftUI
import CoreData

struct BookList: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(
        entity: Book.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Book.createdAt, ascending: true)]
    ) var books: FetchedResults<Book>

    var body: some View {
        NavigationView {
            List {
                ForEach(books) { book in
                    NavigationLink(
                        destination: BookDetail(book: book)
                    ) {
                        BookRow(book: book)
                    }
                }
                .onDelete(perform: { indexSet in
                    for index in indexSet {
                        self.moc.delete(self.books[index])
                    }
                })

                Button(action: { try! self.moc.save() }) {
                    Text("Save")
                }

                Button(action: {
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Book")
                    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                    deleteRequest.resultType = .resultTypeObjectIDs

                    do {
                        let context = self.moc
                        let result = try context.execute(
                            deleteRequest
                        )

                        guard
                            let deleteResult = result as? NSBatchDeleteResult,
                            let ids = deleteResult.result as? [NSManagedObjectID]
                        else { return }

                        let changes = [NSDeletedObjectsKey: ids]
                        NSManagedObjectContext.mergeChanges(
                            fromRemoteContextSave: changes,
                            into: [context]
                        )
                    } catch {
                        print(error as Any)
                    }
                }) {
                    Text("Delete All")
                }

                Button(action: {
                    print("FetchedBooks", books.count)
                    if moc.hasChanges {
                        print("hasChanges!")
                    }
                    print(books)
                }) {
                    Text("Log")
                }

            }
            .navigationBarItems(
                leading: EditButton(),
                trailing: NavigationLink(destination: BookCreate()) { Text("Add") })
            .navigationBarTitle("Books", displayMode: .inline)
        }
    }
}

struct BookList_Previews: PreviewProvider {
    static var previews: some View {
        let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        let _ = SeedData.shared.makeBookList(seedOnce: true)

        return BookList()
            .environment(\.managedObjectContext, moc)
    }
}
