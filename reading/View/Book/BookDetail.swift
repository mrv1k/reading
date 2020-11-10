import SwiftUI

struct BookDetail: View {
    @EnvironmentObject private var settings: AppSettings
    let book: Book

    @StateObject var viewModel: BookDetailViewModel

    init(book: Book) {
        self.book = book
        _viewModel = StateObject(wrappedValue: BookDetailViewModel(book: book))
    }

    var body: some View {
        ScrollView(content: {
            BookRow(book: book)

            BookProgress(progress: viewModel.completionPercent, showLabel: true)

            SessionListBook(book: book, settings: settings)
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
