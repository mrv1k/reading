//
//  SessionRow.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-10-07.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

struct SessionRow: View, ViewModelObserver {
    @ObservedObject var viewModel: SessionRowViewModel
    @EnvironmentObject var settings: AppSettings

    var timeStyle: Text.DateStyle {
        settings.relativeTime ? .relative : .time
    }

    var dateHeader: some View {
        HStack {
            Text(viewModel.weekDay).font(.headline)
                + Text(" ")
                + Text(viewModel.monthDay).foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    var body: some View {
        HStack {
           VStack {
               Text("#####")
               Text("5 hashes")
           }.font(.caption)

            VStack(alignment: .leading) {
                HStack {
                    Text("Avocado Toast").font(.title)
                    Spacer()
                    Rectangle().frame(width: 20, height: 20)
                }

                Text("yada yada yada")
                    .font(.caption).lineLimit(1)
            }
        }
    }
}

struct SessionRow_Previews: PreviewProvider {
    static var previews: some View {
        let book = BookSeeder.preview.fetch(bookWith: .sessions)
        let session = book.sessions.first!

        return SessionRow(viewModel: SessionRowViewModel(session: session))
            .previewLayout(.sizeThatFits)
    }
}

// VStack(alignment: .leading) {
//    if viewModel.showDayLabelForReverseArray {
//        Divider()
//        dateHeader
//    }
//    HStack {
//        Text(viewModel.progress)
//
//        Spacer()
//
//        Text(viewModel.createdAt, style: timeStyle)
//            .font(.subheadline)
//            .foregroundColor(.gray)
//    }
// }
////        .padding(.top, 1)

// HStack {
//    VStack {
//        Text("#####")
//        Text("5 hashes")
//    }.font(.caption)
//
//    VStack(alignment: .leading) {
//        HStack {
//            Text("Avocado Toast").font(.title)
//            Spacer()
//            //                    Text("image")
//            Rectangle().frame(width: 20, height: 20)
//        }
//
//        Text("yada yada yada")
//            .font(.caption).lineLimit(1)
//    }
// }
