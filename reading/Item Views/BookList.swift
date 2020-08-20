import SwiftUI
import Foundation
import CoreData

struct BookList: View {
    @Environment(\.managedObjectContext) var moc

    // @FetchRequest(
    //     entity: Book.entity(),
    //     sortDescriptors: [Book.sortByAuthors]
    // ) var books: FetchedResults<Book>

    // TODO: make last selected sort persistent
    @State private var sortDescriptor: NSSortDescriptor = Book.sortByAuthors

    // @State var books: [Book] = []
    var books: [Book] {
        Book.fetchWithSort(
            moc: self.moc,
            sort: self.sortDescriptor
        )
    }

    var body: some View {
        NavigationView {
            List {
                BookSortMenu(initialSortDescriptor: $sortDescriptor)

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
                    // FIXME: doesn't work with computed sorting
                    // TODO: figure out when to save
                })

                HStack {
                    Button(action: {
                        try! self.moc.saveOnChanges()
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
