import SwiftUI
import Combine

struct BookRow: View {
    var book: Book

    var body: some View {
        VStack(alignment: .leading) {
            Text(book.title)
                .font(.headline)
                .lineLimit(1)
            Text("by \(book.author)")
                .font(.subheadline)
                .fontWeight(.light)
            Text("Page count: \(book.pageCount)")
                .font(.footnote)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct BookRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BookRow(book: BookSeeder.preview.fetch(bookWith: .titleA))
                .previewLayout(.sizeThatFits)

            BookRow(book: BookSeeder.preview.fetch(bookWith: .subtitle))
                .previewLayout(.sizeThatFits)
        }
    }
}
