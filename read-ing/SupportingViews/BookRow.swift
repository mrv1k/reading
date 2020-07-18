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
        NavigationView {
            List {
                BookRow(book: sampleBookList[0])
            }
//             placeholders to make single row item style
//            match list style
            .navigationBarItems(trailing: Button("x") {})
            .navigationBarTitle("x", displayMode: .inline)
        }
    }
}
