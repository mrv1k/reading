import SwiftUI
import Foundation
import CoreData

struct BookList: View {
    @Environment(\.managedObjectContext) var moc

    // @FetchRequest(fetchRequest: NSFetchRequest<Book>(entityName: "Book"))
    // @FetchRequest(
    //     entity: Book.entity(),
    //     sortDescriptors: [Book.alphabeticAuthors]
    // ) var books: FetchedResults<Book>

    @State private var sortDescriptor: NSSortDescriptor = Book.sortByTitle
    // TODO: make last selected sort persistent

    // fixme: recalculated even when the same sort was selected
    var books: [Book] {
        Book.fetchWithSort(
            moc: moc,
            sort: sortDescriptor
        )
    }

    var body: some View {
        NavigationView {
            List {
                BookSortMenu(sortDescriptor: $sortDescriptor)

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
                    // TODO: figure out when to save
                })

                HStack {
                    Button(action: {
                        try! self.moc.save()
                    }) {
                        Text("Save")
                    }
                    .buttonStyle(BorderlessButtonStyle())

                    Button(action: {
                        SeedData.shared.deleteBookList()
                    }, label: {
                        Text("DeleteAll")
                    }).buttonStyle(BorderlessButtonStyle())
                }
            }
            .navigationBarItems(
                leading: EditButton(),
                trailing: NavigationLink(destination: BookCreate()) {
                     Image(systemName: "plus")
                }
            )
            .navigationBarTitle("Books", displayMode: .inline)


        }
    }
}

struct BookList_Previews: PreviewProvider {
    static var previews: some View {
        let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        SeedData.shared.makeBookList(seedOnce: true)

        return BookList()
            .environment(\.managedObjectContext, moc)
    }
}
