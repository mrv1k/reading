// FIXME: Adopt Domain Model
//import Introspect
//import SwiftUI
//
//class BookDetailViewModel: ViewModel {
//    @Published var isCompleted = false
//    @Published var newSessionButtonHidden = false
//    @Published var newSessionInput = ""
//
//    init(book: Book) {
//        isCompleted = book.completed
//    }
//
//    func handleTapGesture() {
//        guard !isCompleted else { return }
//        if newSessionButtonHidden {
//            newSessionButtonHidden = false
//        }
//    }
//}
//
//struct BookDetail: View {
//    @Environment(\.managedObjectContext) private var viewContext
//    let book: DomainBook
//    @StateObject var viewModel: BookDetailViewModel
//
//    init(book: Book) {
//        self.book = book
//        _viewModel = StateObject(wrappedValue: BookDetailViewModel(book: book))
//    }
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 0) {
//            List {
//                Section {
//                    BookProgress(book: book, showLabel: true)
//                        .accentColor(viewModel.isCompleted ? Color.green : nil)
//                }
//
//                SessionListBook(sessions: book.sessions)
//            }
//            .onTapGesture(perform: viewModel.handleTapGesture)
//            .listStyle(InsetGroupedListStyle())
//
//            if !viewModel.isCompleted {
//                HStack {
//                    if viewModel.newSessionButtonHidden {
//                        HStack {
//                            TextField("hello", text: $viewModel.newSessionInput)
//                                .textFieldStyle(RoundedBorderTextFieldStyle())
//                                .introspectTextField { $0.becomeFirstResponder() }
//
//                            Image(systemName: "paperplane.circle.fill").font(.title)
//                        }
//                        .padding()
//                    } else {
//                        addSessionButton
//                    }
//                }
//            }
//        }
//        .navigationBarTitle(book.title)
//    }
//
//    var addSessionButton: some View {
//        HStack {
//            Button {
//                viewModel.newSessionButtonHidden = true
//            } label: {
//                Label("New Session", systemImage: "plus.circle.fill")
//                    .font(Font.title3.bold())
//                    .padding() // keep padding here to increase tap area
//            }
//            Spacer()
//        }
//        .background(Color(UIColor.systemGray6))
//    }
//}
//
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
