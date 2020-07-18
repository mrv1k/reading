import Foundation
import SwiftUI

struct Book: Identifiable {
    let id: Int
    var title: String
    var subtitle: String?
    var authors: [String]
    var pageCount: Int
    var image: Image?
    var isEbook = false
}

//types of images
//Image
//CGImage
//UIImage
//CIImage
