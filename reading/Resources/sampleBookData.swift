let book0 = Book(
    id: 0,
    title: "Crime and Punishment",
    authors: ["Fyodor Dostoyevsky"],
    pageCount: 1000
)

//    "Shoe Dog: A Memoir by the Creator of NIKE"
let book1 = Book(
    id: 1,
    title: "Shoe Dog",
    subtitle: "A Memoir by the Creator of NIKE",
    authors: ["Phil Knight"],
    pageCount: 400
)

let book2 = Book(
    id: 2,
    title: "The Swift Programming Language",
    subtitle: "(Swift 5.2 Edition)",
    authors: ["Apple Inc.", "Another Author"],
    pageCount: 500,
    image: "swift_book_cover",
    isEbook: true
)

let book3 = Book(
    id: 3,
    title: "Good Omens",
    authors: ["Neil Gaiman", "Terry Pratchett"],
    pageCount: 288
)

let sampleBookArray = [book0, book1, book2, book3]

let sampleBookWith = [
    "minimum": book0,
    "subtitle": book1,
    "everything": book2,
    "2_authors": book3,
]

