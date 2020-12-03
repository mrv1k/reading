import SwiftUI

class BookDetailViewModel: ViewModel {
    @Published var isAddSessionActive = false
}

struct BookDetail: View {
    @Environment(\.managedObjectContext) private var viewContext
    let book: Book
    @StateObject var viewModel = BookDetailViewModel()

    var addSessionButton: some View {
        HStack {
            Button {
                viewModel.isAddSessionActive.toggle()
            } label: {
                Label("New Session", systemImage: "plus.circle.fill")
                    .font(Font.title3.bold())
                    .padding()
                    .padding(.top, 0)
            }
            Spacer()
        }
        .background(Color(UIColor.systemGray6))
    }

    @ViewBuilder
    var EditButton2: some View {
        if !viewModel.isAddSessionActive {
            EditButton()
        } else {
            EmptyView()
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            List {
                Section {
                    BookProgress(book: book)
                }

                SessionListBook(viewContext: viewContext,
                                book: book,
                                isAddSessionActivePublisher: viewModel.$isAddSessionActive)
            }
            .listStyle(InsetGroupedListStyle())

            if !viewModel.isAddSessionActive {
                addSessionButton
            }
        }
//        .environment(\.editMode, $viewModel.editMode)
        .navigationBarTitle(book.title)
        .toolbar { EditButton2 }
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
