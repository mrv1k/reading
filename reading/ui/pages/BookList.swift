import SwiftUI

struct BookList: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var unitOfWork: UnitOfWork

    var books: [DomainBook] { unitOfWork.books }

    @State private var createOpen = false

//    FIXME: re-enable
//    var menu: some View {
//        Menu {
//            BookListSortPicker()
//        } label: {
//            Image(systemName: "ellipsis.circle")
//                .imageScale(.large)
//                .padding([.vertical, .leading])
//        }
//    }

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
//            .onDelete(perform: deleteBook)
        }
        .listStyle(InsetGroupedListStyle())
        .animation(.default)
        .navigationBarTitle("Library")
//        .toolbar {
//            ToolbarItem(placement: ToolbarItemPlacement.primaryAction) {
//                menu
//            }
//        }
    }

//    func deleteBook(indexSet: IndexSet) {
//        withAnimation {
//            for index in indexSet {
//                viewContext.delete(self.books[index])
//            }
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
}

//struct BookList_Previews: PreviewProvider {
//    static var previews: some View {
//        let viewContext = PersistenceController.preview.container.viewContext
//
//        return Group {
//            BookList()
//                .previewDisplayName("No Navigation")
//
//            NavigationView {
//                BookList()
//            }
//        }
//        .environment(\.managedObjectContext, viewContext)
////        .environmentObject(BookStorage(viewContext: viewContext))
//    }
//}
