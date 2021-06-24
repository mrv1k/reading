# Reading / iOS App / 2020 CS50 Final Project

by Viktor Khotimchenko from Toronto, Canada

## Video Demo: https://youtu.be/gJdDpV96Ms4
## Git Repository: https://github.com/mrv1k/reading

This project was inspired by iOS track [tracks/mobile/ios](https://cs50.harvard.edu/x/2020/tracks/mobile/ios/)

This was an ambitious project to learn iOS app development and create an app at the same time. Learning was successful, shipping an app - not.
As it stands right now, the app is at the latest working commit I could find. It's okay as a prototype but nothing more.

## How does the app work?

The idea idea is to track reading sessions for a book.
You can create a book and add sessions to it.
Assuming you're reading book in chronological order you only need to ender the end page.
Session will fetch previous session last page and calculate progress automatically.

Session display can be configured in "Settings" tab:
+ User can choose between displaying sessions in pages or percentages
+ User can choose between displaying session in chronological or reverse chronological order


## Technologies used

- **Swift**. Swift is a great language. The language was what motivated me to work on an app.
- **SwiftUI**. SwiftUI 2.0 is good, but at the time I was writing this project was still new and poorly documented. Writing declarative UI is fun until you have to read the docs.
- **Core Data**. Tight integration with Core Data was what sidetracked this project into a ditch. It was by far the hardest part of the project. CD required enormous amount of efforts to gain even a little understanding. Definitely would not recommend learning it.
- **Combine**. Combine is a good functional reactive programming library. The con is Swift's typesystem does not play nice with Combine and you have to pollute code with endless .eraseToAnyPublisher()
- Packages
  - SwiftCSV
  - Introspect

## Technologies that should have been used

- **UIKit**. I have avoided it like a wildfire while writing this app, I have tried to learn it since then and I can safely admit it's not something I want to work with again. It's so unbelievably verbose.
- Storyboards. Some sort of XML with UI wrapped on top of it. On more than one occasion almost melted my poor 2015 Macbook pro.


## Possible features
The sky is the limit for this app.
For books:
+ Covers
+ Support for ebooks
+ Co-authored books
+ Option to re-read a book

For sessions:
+ Non chronological reading
+ A timer could be added to each session.
+ A built in music player would be great for immersion,

## Postmortem

In July of 2020 I'd set out to learn iOS development and build an app at the same time. (December of 2020) I've learned a ton about iOS However, I have no app. Why? I neglected learning UIKit. The app idea requires UIKit. I got buried too deep in implementation details only to have a very painful awakening. The app either had to be rewritten or dropped.

I dropped it. Dropping a half a year of work was painful, very painful. Despite the fact that it feels like I made all the mistakes I could, it's a invaluable experience for my growth as a software developer. I wouldn't change it even if I could.

p.s.: Don't learn Apple's new frameworks. The documentation is [terrible](https://prog.world/apples-terrible-documentation/).

[HackingWithSwift](https://www.hackingwithswift.com/) is the best.
