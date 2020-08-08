import SwiftUI

struct BookRow: View {
    var book: Book

    var createdAt: String {
        let formatter = DateFormatter()
        // yyyy-MM-dd 
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter.string(from: book.createdAt)
    }

    var body: some View {
        // Image("swift_book_cover")
        //     .resizable()
        //     .border(Color.black)
        //     .frame(width: 70, height: 105)
        VStack(alignment: .leading) {
            Text(book.title)
                .font(.headline)
                // .fontWeight(.semibold)
                .lineLimit(1)
            Text(book.authors)
                .font(.subheadline)
                .fontWeight(.light)
            Text("Page count: \(book.pageCount)")
                .font(.footnote)

            Text(createdAt)

        }
        .multilineTextAlignment(.leading)
    }
}

struct BookRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BookRow(book: SeedData.shared.makeBook(with: .everything))
                .previewLayout(.sizeThatFits)
        }
    }
}
