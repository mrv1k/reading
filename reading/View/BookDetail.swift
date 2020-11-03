import SwiftUI
import CoreData
import Combine

class BookDetailVM: ObservableObject {
    var cancellableSet = Set<AnyCancellable>()
    @Published var raw_completionPercent: Int16 = 0
    // @Published var test: Double = 0
}

struct BookDetail: View {
    @StateObject var VM = BookDetailVM()
    let book: Book

    var body: some View {
        VStack(alignment: .leading) {
            BookRow(book: book)

            Text("\(book.raw_completionPercent)")

            Text("\(VM.raw_completionPercent)")

            ProgressView(value: Double(book.raw_completionPercent), total: 1000)
            {}
            currentValueLabel: { Text("\(book.raw_completionPercent)%") }

            ProgressView(value: Double(VM.raw_completionPercent), total: 1000)
            {}
            currentValueLabel: { Text("\(VM.raw_completionPercent)%") }

            SessionListBook(book: book)
        }
        .frame(maxHeight: .infinity, alignment: .topLeading)
        .padding([.horizontal, .top], 20)
        .onAppear {
            book.publisher(for: \.raw_completionPercent)
                .assign(to: \BookDetailVM.raw_completionPercent, on: VM)
                .store(in: &VM.cancellableSet)
        }
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
