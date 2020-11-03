import SwiftUI
import CoreData

struct BookDetail: View {
    let book: Book

    var body: some View {
        VStack(alignment: .leading) {
            BookRow(book: book)


            Text("\(book.raw_completionPercent)")

            // ProgressView(value: proxy, total: 1000)
            // {}
            // currentValueLabel: { Text("\(proxy)%") }

            SessionListBook(book: book)
        }
        .frame(maxHeight: .infinity, alignment: .topLeading)
        .padding([.horizontal, .top], 20)
        .navigationBarItems(trailing: SimpleSessionCreate(book: book))
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
