//
//  SimpleSessionCreate.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-10-06.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

struct SimpleSessionCreate: View {
    @State var book: Book

    @State private var endPageField = ""
    @State private var isPresented = false

    var body: some View {
        Button {
            isPresented = true
        } label: {
            Image(systemName: "plus")
                .imageScale(.large)
                .padding([.vertical, .leading], 10)
        }
        .sheet(isPresented: $isPresented) {
            VStack {
                HStack {
                    Button("Cancel") {
                        print("cancel")
                        isPresented = false
                    }
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .buttonStyle(BorderlessButtonStyle())

                    Text("Details").bold()

                    Button {
                        print("save")
                        isPresented = false
                    } label: {
                        Text("Save").bold()
                    }
                    .frame(maxWidth: .infinity, alignment: .topTrailing)
                    .buttonStyle(BorderlessButtonStyle())
                }
                .padding(.init(top: 18, leading: 20, bottom: 0, trailing: 20))

                Form {
                    TextField("End page", text: $endPageField)
                        .keyboardType(.numberPad)
                }

                Spacer()
            }
            .background(Color(UIColor.systemGray6))
        }
    }
}

struct SimpleSessionCreate_Previews: PreviewProvider {
    static var previews: some View {
        SimpleSessionCreate(book: BookSeeder.preview.fetch(bookWith: .sessions))
    }
}
