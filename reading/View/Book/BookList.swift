import SwiftUI

struct BookList: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var bookStorage: BookStorage
    var books: [Book] { bookStorage.books }

    // Hack. Use programmatic NavigationLink to enable navigation from modal Menu
    @State private var activeLink: String?

    var navigationLinkProxies: some View {
        Group {
            NavigationLink("", destination: SessionCreate(), tag: "SessionCreate", selection: $activeLink)
            NavigationLink("", destination: BookCreate(), tag: "BookCreate", selection: $activeLink)
        }
        .frame(width: 0, height: 0)
    }

    var menu: some View {
        Menu {
            Button(action: { activeLink = "SessionCreate" },
                   label: { Label("New Session", systemImage: "plus") })
            Button(action: { activeLink = "BookCreate" },
                   label: { Label("New Book", systemImage: "plus") })
            Divider()
            BookListSortPicker()
        } label: {
            Image(systemName: "ellipsis.circle")
                .imageScale(.large)
                .padding([.vertical, .leading])
        }
    }

    var body: some View {
        List {
            ForEach(books) { book in
                NavigationLink(
                    destination: BookDetail(book: book),
                    label: {
                        BookRow(book: book)
                    })
            }
            .onDelete(perform: deleteBook)
        }
        .animation(.default)
        .navigationBarItems(
            leading: NavigationLink(
                destination: SettingsEditor(),
                label: {
                    Image(systemName: "gearshape")
                        .imageScale(.large)
                        .padding([.vertical, .trailing])
                }),
            trailing: Group {
                menu
                navigationLinkProxies
            }

        )
        .navigationBarTitle("Books", displayMode: .inline)
    }

    func deleteBook(indexSet: IndexSet) {
        withAnimation {
            for index in indexSet {
                viewContext.delete(self.books[index])
            }
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct BookList_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.preview.container.viewContext

        return Group {
            BookList()
                .previewDisplayName("No Navigation")

            NavigationView {
                BookList()
            }
        }
        .environment(\.managedObjectContext, viewContext)
        .environmentObject(BookStorage(viewContext: viewContext))
    }
}
