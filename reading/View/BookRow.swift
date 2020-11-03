import SwiftUI
import Combine

struct BookRow: View {
    var book: Book

    var body: some View {
        VStack(alignment: .leading) {
            Text(book.title)
                .font(.headline)
                .lineLimit(1)
            Text(book.author)
                .font(.subheadline)
                .fontWeight(.light)
            Text("Page count: \(book.pageCount)")
                .font(.footnote)
        }
        .multilineTextAlignment(.leading)
    }
}

struct BookRow_Previews: PreviewProvider {
    static var previews: some View {
        BookRow(book: BookSeeder.preview.fetch(bookWith: .subtitle))
            .previewLayout(.sizeThatFits)
    }
}
