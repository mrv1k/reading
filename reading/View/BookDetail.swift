import SwiftUI
import CoreData

struct BookDetail: View {
    @Environment(\.presentationMode) private var isActive
    let book: Book

    var body: some View {
        VStack(alignment: .leading) {
            BookRow(book: book)
            // Divider()

            ProgressView(value: Double(book.raw_completionPercent), total: 1000)
            {}
            currentValueLabel: {
                Text("\(book.raw_completionPercent)%")
            }


            SessionListBook(sessions: book.sessions)
        }
        .frame(maxHeight: .infinity, alignment: .topLeading)
        .padding(.horizontal, 20)
        .padding(.top, 20)

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
