# Reading / iOS App / 2020 CS50 Final Project

This project was inspired by iOS track [tracks/mobile/ios](https://cs50.harvard.edu/x/2020/tracks/mobile/ios/)

This was an ambitious project to learn iOS app development and create an app at the same time. Learning was successful, shipping an app - not. As it stands right now, the app is at the latest working commit I could find. It's okay as a prototype but nothing more.

## How does the app work?

The idea idea is to track reading sessions for a book. You can create a book and add sessions to it. Assuming you're reading book in chronological order you only need to ender the end page, session calculates progress automatically.

## Technologies used

- Swift
- SwiftUI
- Core Data
- Combine
- Packages
  - SwiftCSV
  - Introspect

## Postmortem

In July of 2020 I'd set out to learn iOS development and build an app at the same time. (December of 2020) I've learned a ton about iOS However, I have no app. Why? I neglected learning UIKit. The app idea requires UIKit. I got buried too deep in implementation details only to have a very painful awakening. The app either had to be rewritten or dropped.

p.s.: Don't learn Apple's new frameworks. The documentation is [terrible](https://prog.world/apples-terrible-documentation/). [HackingWithSwift](https://www.hackingwithswift.com/) is the best.
