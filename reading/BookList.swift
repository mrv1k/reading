import SwiftUI

struct BookList: View {
    @Environment(\.managedObjectContext) var context
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

                // Button(action: {
                //     print(self.userData.books)
                //     print(self.userData.books.count, sampleBookArray.count)
                // }) {
                //     Text("Log")
                // }
            }
            .navigationBarItems(trailing: NavigationLink(destination: BookCreate()) {
                Text("Add")
            })
            .navigationBarTitle("Books", displayMode: .inline)
        }
    }
}

struct BookList_Previews: PreviewProvider {
    static var previews: some View {
        BookList()
            .environment(\.managedObjectContext, SeedData.shared.context)

    }
}
