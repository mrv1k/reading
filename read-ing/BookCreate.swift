import SwiftUI

struct BookCreate: View {
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
                    print("add", self.pageCount)

                    guard let pageCount = Int(self.pageCount) else {
//                        pageCountField is invalid
                        return
                    }

                    var authors = self.authors.components(separatedBy: ", ")
                    authors = authors.map { $0.trimmingCharacters(in: .whitespaces) }

                    let book = Book(
                        id: sampleBookArray.count - 1,
                        title: self.title,
                        authors: authors,
                        pageCount: pageCount
                    )
                    sampleBookArray.append(book)
//                    print(selection)

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
    }
}
