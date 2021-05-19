import Introspect
import SwiftUI

class BookDetailViewModel: ViewModel {
    @Published var newSessionButtonHidden = false
    @Published var newSessionInput = ""
    @Published var editMode = EditMode.inactive
    
    var sessionCreateFieldViewModel: SessionCreateFieldViewModel
    init(book: Book) {
        sessionCreateFieldViewModel = SessionCreateFieldViewModel(book: book)
    }
}

struct BookDetail: View {
    @Environment(\.managedObjectContext) private var viewContext
    let book: Book
    @StateObject var viewModel: BookDetailViewModel

    init(book: Book) {
        self.book = book
        _viewModel = StateObject(wrappedValue: BookDetailViewModel(book: book))
    }
    var addSessionButton: some View {
        HStack {
            Button {
                viewModel.newSessionButtonHidden = true
            } label: {
                Label("New Session", systemImage: "plus.circle.fill")
                    .font(Font.title3.bold())
                    .padding() // keep padding here to increase tap area
            }
            Spacer()
        }
        .background(Color(UIColor.systemGray6))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            List {
                Section {
                    BookProgress(book: book, showLabel: true)
                }

                SessionListBook(sessions: book.sessions)
            }
            .onTapGesture {
                if viewModel.newSessionButtonHidden {
                    viewModel.newSessionButtonHidden = false
                }
            }
            .listStyle(InsetGroupedListStyle())

            if book.raw_completionPercent < 999 {
                HStack {
                    if viewModel.newSessionButtonHidden {
                        SessionCreateField(viewModel: viewModel.sessionCreateFieldViewModel)
                            .padding()
                    } else {
                        addSessionButton
                    }
                }
            }
        }
        .navigationBarTitle(book.title)
    }
}

//struct BookDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        return Group {
//            BookDetail(book: BookSeeder.preview.fetch(bookWith: .sessions))
//                .previewLayout(.sizeThatFits)
//
//            NavigationView {
//                BookDetail(book: BookSeeder.preview.fetch(bookWith: .sessions))
//                    .navigationBarTitle("", displayMode: .inline)
//            }
//            .previewDevice("iPhone SE (2nd generation)")
//        }
//    }
//}
