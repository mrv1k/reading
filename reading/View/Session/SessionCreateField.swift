////
////  SessionCreateField.swift
////  reading
////
////  Created by Viktor Khotimchenko on 2020-11-19.
////  Copyright © 2020 mrv1k. All rights reserved.
////
//
//import SwiftUI
//
//class SessionCreateFieldViewModel: ViewModel {
//    private var book: Book
//
//    init(book: Book) {
//        self.book = book
//    }
//
//    @Published var input = ""
//}
//
//struct SessionCreateField: View, ViewModelObserver {
//    let book: Book
//
//    @ObservedObject var viewModel: SessionCreateFieldViewModel
//
//    var body: some View {
//        TextField("Placeholder", text: $viewModel.input)
//    }
//}
//
//struct SessionCreateField_Previews: PreviewProvider {
//    static var previews: some View {
//        SessionCreateField(book: BookSeeder.preview.fetch(bookWith: .sessions))
//            .previewLayout(.sizeThatFits)
//    }
//}


//HStack {
//    TextField("I'm on page", text: $viewModel.pageEndField)
//        .keyboardType(.numberPad)
//        .textFieldStyle(RoundedBorderTextFieldStyle())
//
//    Button {
//        viewModel.save(context: viewContext)
//    } label: {
//        Image(systemName: "plus.circle.fill").imageScale(.large)
//    }
//}

//func save(context: NSManagedObjectContext) {
//    let session = Session(context: context)
//    session.book = book
//    session.pageEnd = Int16(pageEndField)!
//    try! context.saveOnChanges(session: session)
//    pageEndField = ""
//}
