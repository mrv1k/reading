import SwiftUI

struct BookList: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var unitOfWork: UnitOfWork

    var books: [DomainBook]

    @State private var createOpen = false

    var body: some View {
        List {
            Button { createOpen = true } label: { Label("New Book", systemImage: "plus") }
                .sheet(isPresented: $createOpen, content: {
                    BookCreate(repository: unitOfWork.repository)
                })

            ForEach(books) { book in
                NavigationLink(destination: EmptyView(), // BookDetail(book: book)
                               label: { BookRow(book: book) })
            }
        }
        .listStyle(InsetGroupedListStyle())
        .animation(.default)
        .navigationBarTitle("Library")
        .toolbar {
            ToolbarItem(placement: ToolbarItemPlacement.primaryAction) {
                menu
            }
        }
    }

    var menu: some View {
        Menu {
            BookListSortPicker()
        } label: {
            Image(systemName: "ellipsis.circle")
                .imageScale(.large)
                .padding([.vertical, .leading])
        }
    }
}

struct BookList_Previews: PreviewProvider {
    static var previews: some View {
        let books = [
            DomainBook(title: "titleA", author: "authorA", pageCount: 100),
            DomainBook(title: "titleB", author: "authorB", pageCount: 200)
        ]

        return Group {
            NavigationView {
                BookList(books: books)
            }
        }
        .previewDevice("iPhone SE (2nd generation)")
    }
}
