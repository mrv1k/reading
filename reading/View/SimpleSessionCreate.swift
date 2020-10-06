//
//  SimpleSessionCreate.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-10-06.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

struct SimpleSessionCreate: View {
    @State var pageField = ""
    @State var tbd: Book?
    @State var isPresented = true

    var body: some View {
        Button("test") {
            isPresented = true
        }
        .sheet(isPresented: $isPresented) {
            print("onDismiss")
        } content: {
            ZStack {
            VStack {
                HStack {
                    Button("Cancel") {
                        print("cancel")
                        isPresented = false
                    }
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .buttonStyle(BorderlessButtonStyle())


                    Text("Details")
                        .bold()

                    Button {
                        print("save")
                        isPresented = false
                    } label: {
                        Text("MINE")
                            .bold()
                    }
                    .frame(maxWidth: .infinity, alignment: .topTrailing)
                    .buttonStyle(BorderlessButtonStyle())
                }
                .zIndex(1)
                .padding(.init(top: 18, leading: 20, bottom: 0, trailing: 20))

                Form {
                    TextField("End page", text: $pageField)
                        .keyboardType(.numberPad)

                    BookListModal(bookSelection: $tbd)
                    if let bookSelected = tbd {
                        BookRow(book: bookSelected)
                    }
                }
                // .offset(CGSize(width: 0, height: -22.0))

                Spacer()
            }
            .background(Color(UIColor.systemGray6))
            }
        }
    }
}

struct SimpleSessionCreate_Previews: PreviewProvider {
    static var previews: some View {
        SimpleSessionCreate()
    }
}
