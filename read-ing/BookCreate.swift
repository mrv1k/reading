import SwiftUI

struct BookCreate: View {
    @Environment(\.presentationMode) private var isActive
    @EnvironmentObject var userData: UserData

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
                VStack(alignment: .center) {
                    Divider()
                    BookCover()
                }
            }

            Section(header: Text("INFORMATION")) {
                TextField("Title", text: $title)

                //            if subtitle != nil {
                //                Text(subtitle!)
                //            }

                TextField("Author(s)", text: $authors)

                TextField("Pages", text: $pageCount)
                    .keyboardType(.numberPad)
            }

            Section {
                Button(action: {
                    guard let pageCount = Int(self.pageCount) else {
//                        pageCountField is invalid
                        return
                    }

                    var authors = self.authors.components(separatedBy: ", ")
                    authors = authors.map { $0.trimmingCharacters(in: .whitespaces) }

                    let book = Book(
                        id: sampleBookArray.count,
                        title: self.title,
                        authors: authors,
                        pageCount: pageCount
                    )
                    self.userData.books.append(book)
                    print(book)

//                    add another or
                    self.isActive.wrappedValue.dismiss()
                }) {
                    Text("Save")
                }
            }
        .disabled(hasEmptyRequiredField)
        }
        .navigationBarTitle("Add a book", displayMode: .inline)
    }
}

struct BookCreate_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PreviewWithNavigation(anyView: AnyView(BookCreate()))
            BookCreate()
        }
        .environmentObject(UserData())
    }
}
