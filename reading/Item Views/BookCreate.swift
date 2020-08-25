import SwiftUI

struct BookCreate: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var isActive

    @State private var image: Image?
    @State private var title = ""
    @State private var subtitle: String?
    @State private var authors = ""
    @State private var pageCount = ""

    var hasEmptyRequiredField: Bool {
        title.isEmpty || authors.isEmpty || pageCount.isEmpty
    }

    var body: some View {
        Form {
            Section(header: Text("COVER")) {
                HStack {
                    Spacer()
                    BookCover()
                    Spacer()
                }
            }

            Section(header: Text("INFORMATION")) {
                TextField("Title", text: $title)

                TextField("Author(s)", text: $authors)

                TextField("Pages", text: $pageCount)
                    .keyboardType(.numberPad)
            }

            Section {
                Button(action: {
                    guard let pageCount = Int16(self.pageCount) else {
                        // pageCountField is invalid
                        return
                    }

                    let book = Book(context: self.viewContext)
                    book.title = self.title
                    book.authors = self.authors
                    book.pageCount = pageCount

                    do {
                        try self.viewContext.saveOnChanges()
                        print("saved", book)
                    } catch {
                        print(error.localizedDescription)
                    }

                    // TODO: ask to add another
                    // if no
                    self.isActive.wrappedValue.dismiss()
                }) {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                }
            }
            .disabled(hasEmptyRequiredField)
        }
        .navigationBarTitle("Add a book", displayMode: .inline)
    }
}

struct BookCreate_Previews: PreviewProvider {
    static var previews: some View {
        BookCreate()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
