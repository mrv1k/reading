import SwiftUI

struct BookList: View {
    var books: [Book]

    var body: some View {
        NavigationView {
            List {
                ForEach(books) { book in
                    NavigationLink(destination: BookDetail(book: book)) {
                        BookRow(book: book)
                    }
                }
            }
            .navigationBarItems(trailing: Button("Add") {})
            .navigationBarTitle("Books", displayMode: .inline)

        }
    }
}

struct BookList_Previews: PreviewProvider {
    static var previews: some View {
        BookList(books: sampleBookArray)
    }
}
