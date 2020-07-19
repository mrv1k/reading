import SwiftUI

struct BookDetail: View {
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

//            Text("isEbook \(book.isEbook ? "true" : "false")")
        }
    }
}

struct BookDetail_Previews: PreviewProvider {
    static var previews: some View {
        BookDetail(book: sampleBookWith["everything"]!)
//        BookDetail(book: sampleBookWith["2_authors"]!)
    }
}
