import SwiftUI

struct BookRow: View {
    var book: Book

    var body: some View {
        HStack {
            Text(book.title)
                .lineLimit(1)
            Spacer()
//            Text(book.author) // FIXME
            Spacer()
            Text(String(book.pageCount))
        }.multilineTextAlignment(.leading)
    }
}

struct BookRow_Previews: PreviewProvider {
    static var previews: some View {
        BookRow(book: SeedData.shared.book1())
    }
}
