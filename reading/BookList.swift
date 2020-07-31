import SwiftUI

struct BookList: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Book.entity(), sortDescriptors: [])

    var books: FetchedResults<Book>

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

                Button(action: {
                    print(self.books)
                    print("FetchedBooks", self.books.count)
                    self.moc.perform {
                        do {
                            try self.moc.save()
                            print("saved")
                        } catch {
                            print("failed save")
                            print(error)
                        }
                    }
                }) {
                    Text("Save & Log")
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
        // for some unknown reason doesnt work with SeedData.shared.context
        // let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        BookList()
            .environment(\.managedObjectContext, SeedData.shared.moc)
            // .environment(\.managedObjectContext, moc)
    }
}
