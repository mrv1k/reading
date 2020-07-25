import SwiftUI

struct BookDetail: View {
    @Environment(\.presentationMode) private var isActive
    let book: Book

    var body: some View {
        VStack {
            if book.image != nil {
                Image(book.image!)
            }

            Text(book.title)

            if book.subtitle != nil {
                Text(book.subtitle!)
            }

            Text("by " + book.authors.joined(separator: ", "))

            Text(String(book.pageCount) + " pages")

            Button(action: {
                self.isActive.wrappedValue.dismiss()
            }) {
                Text("OK")
            }

//            Text("isEbook \(book.isEbook ? "true" : "false")")
        }
    }
}

struct BookDetail_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BookDetail(
                book: sampleBookWith["everything"]!
            )

            PreviewWithNavigation(
                anyView: AnyView(BookDetail(book: sampleBookWith["everything"]!))
            )
        }
        .environmentObject(UserData())
    }
}
