import SwiftUI
import CoreData

struct BookDetail: View {
    @Environment(\.presentationMode) private var isActive
    let book: Book

    @State var pageProgress = true

    var body: some View {
        VStack(alignment: .leading) {
            BookRow(book: book)
                .padding(.horizontal, 20)
                .padding(.top, 20)

            Divider()

            SessionListBook(book: book, pageProgress: $pageProgress)
        }
        .frame(maxHeight: .infinity, alignment: .topLeading)

        // NavigationLink("Add a reading session",
        //                destination: SessionCreate(book: book))
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
