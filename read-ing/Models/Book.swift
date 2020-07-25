struct Book: Identifiable {
    let id: Int
    var title: String
    var subtitle: String?
    var authors: [String]
    var pageCount: Int
    var image: String?
    var isEbook = false
}
