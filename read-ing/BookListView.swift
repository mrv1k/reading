import SwiftUI

struct BookListView: View {
    var books: [Book]

    var body: some View {
        NavigationView {
            List {
                HStack {
                    Text(books[0].author)
                    Text(books[0].title)
                    Text(books[0].pageCount)
                }
//                ForEach(books) { book in
//                    Text(book.author)
//                    Text(book.title)
//                    Text(book.pageCount)
//                }
            }
//            .navigationBarItems(trailing:
//                Button(action: {
//                    // Add action
//                }, label: {
//                    Text("Add")
//                })
//            )
            .navigationBarTitle("Books")
        }
    }
}

struct BookListView_Previews: PreviewProvider {
    static var previews: some View {
        BookListView(books: [
            Book(
                title: "Crime and Punishment",
                author: "Dostoevsky",
                pageCount: "600"
            )
        ])
    }
}
