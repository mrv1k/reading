import SwiftUI

struct BookDetail: View {
    let book: Book

    var body: some View {
        ScrollView(content: {
            BookRow(book: book)

            BookProgress(book: book, showLabel: true)

            SessionListBook(book: book)
        })
        .frame(maxHeight: .infinity, alignment: .topLeading)
        .padding([.horizontal, .top], 20)
    }
}

struct BookDetail_Previews: PreviewProvider {
    static var previews: some View {
        return Group {
            BookDetail(book: BookSeeder.preview.fetch(bookWith: .sessions))
                .previewLayout(.sizeThatFits)

            NavigationView {
                BookDetail(book: BookSeeder.preview.fetch(bookWith: .sessions))
                    .navigationBarTitle("", displayMode: .inline)
            }
            .previewDevice("iPhone SE (2nd generation)")
        }
    }
}
