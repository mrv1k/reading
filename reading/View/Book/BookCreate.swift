import SwiftUI

struct BookCreate: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var isActive

    @State private var image: Image?
    @State private var title = ""
    @State private var subtitle: String?
    @State private var author = ""
    @State private var pageCount = ""

    var hasEmptyRequiredField: Bool {
        title.isEmpty || author.isEmpty || pageCount.isEmpty
    }

    var body: some View {
        Form {
            Section(header: Text("INFORMATION")) {
                TextField("Title", text: $title)

                TextField("Author(s)", text: $author)

                TextField("Pages", text: $pageCount)
                    .keyboardType(.numberPad)
            }

            Section {
                Button(action: {
                    guard let pageCount = Int16(self.pageCount) else {
                        // FIXME: handle pageCountField is invalid
                        return
                    }

                    let book = Book(context: self.viewContext)
                    book.title = title
                    book.author = author
                    book.pageCount = pageCount

                    do {
                        try self.viewContext.saveOnChanges()
                    } catch {
                        print(error.localizedDescription)
                    }

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
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
