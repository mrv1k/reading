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
