import SwiftUI

class BookDetailViewModel: ViewModel {
    var book: Book

    var bookProgress: BookProgressViewModel

    @Published var editMode = EditMode.inactive

    init(book: Book) {
        self.book = book

        bookProgress = BookProgressViewModel(book: book, showLabel: true)
    }
}

struct BookDetail: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject var viewModel: BookDetailViewModel

    init(book: Book) {
        _viewModel = StateObject(wrappedValue: BookDetailViewModel(book: book))
    }

    var addSessionButton: some View {
        HStack {
            Button {
                viewModel.editMode = .active
            } label: {
                Label("New Session", systemImage: "plus.circle.fill")
                    .font(Font.title3.bold())
                    .padding(.all)
                    .padding(.top, 0)
            }
            Spacer()
        }
        .background(Color(UIColor.systemGray6))
    }

    var AddButtonWhenEditInactive: some View {
        Group {
            if viewModel.editMode == .inactive {
                addSessionButton
            } else {
                EmptyView()
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            List {
                Section {
                    BookProgress(viewModel: viewModel.bookProgress)
                }

                SessionListBook(viewContext: viewContext,
                                sessions: viewModel.book.sessions,
                                editModePublisher: viewModel.$editMode)
            }
            .listStyle(InsetGroupedListStyle())

            AddButtonWhenEditInactive
        }
        .navigationBarTitle(viewModel.book.title)
        .toolbar { EditButton() }
        .environment(\.editMode, $viewModel.editMode)
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
