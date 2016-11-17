![Ax](ax-logo.png)
-----
[![CI Status](https://img.shields.io/travis/wilsonbalderrama/Ax.svg?style=flat)](https://travis-ci.org/wilsonbalderrama/Ax)
[![CocoaPods compatible](https://img.shields.io/badge/CocoaPods-compatible-4BC51D.svg)](https://github.com/CocoaPods/CocoaPods)
[![Version](https://img.shields.io/cocoapods/v/Ax.svg?style=flat)](http://cocoapods.org/pods/Ax)
[![License](https://img.shields.io/cocoapods/l/Ax.svg?style=flat)](http://cocoapods.org/pods/Ax)
[![Platform](https://img.shields.io/cocoapods/p/Ax.svg?style=flat)](http://cocoapods.org/pods/Ax)



**Ax** is a library written in **Swift** that helps you to control the flow of asynchronous executions in a organized way.
Inspired by [async library](https://github.com/caolan/async).
##Overview

- [What’s It For?](https://github.com/wilsonbalderrama/Ax#whats-it-for)
  - [The Problem](https://github.com/wilsonbalderrama/Ax#the-problem)
  - [The Solution](https://github.com/wilsonbalderrama/Ax#the-solution)
  - [Important aspects](https://github.com/wilsonbalderrama/Ax#important-aspects-to-mention-are)
- [Supported Functions](https://github.com/wilsonbalderrama/Ax#supported-functions)
  - [Serial](https://github.com/wilsonbalderrama/Ax#serial)
  - [Parallel](https://github.com/wilsonbalderrama/Ax#parallel)
- [Installation](https://github.com/wilsonbalderrama/Ax#installation)
- [Usage](https://github.com/wilsonbalderrama/Ax#usage)

##Requirements
- Xcode 8.0+
- Swift 3.0+
- iOS 9.0+

##What’s It For?

###The Problem

For example there could be a case when your asynchronous calls depend each other to run so a naive solution could be nesting your calls like in the example below:

```swift

runAsync(afterSeconds: 2, completion: {
  let dataFromTask1 = 1

  self.runAsync(afterSeconds: 2, completion: {
    let dataFromTask2 = 2

    self.runAsync(afterSeconds: 2, completion: {
      let dataFromTask3 = 3

      self.runAsync(afterSeconds: 2, completion: {
        let dataFromTask4 = 4

        print(dataFromTask1) // 1
        print(dataFromTask2) // 2
        print(dataFromTask3) // 3
        print(dataFromTask4) // 4
      })
    })
  })
})
```

Nesting your asynchronous calls is a common known problem in programming that the community names it as: [callback hell](http://callbackhell.com/), [pyramid of doom](https://en.wikipedia.org/wiki/Pyramid_of_doom_(programming)).

We should avoid this kind of code because it can lead to some really confusing and difficult-to-read code, it is a bad practice.

### The Solution
That is when it comes in play Ax, it helps you to call your async calls in a linear way giving the impression that you were running synchronous calls:

```swift
import Ax

var dataFromTask1 = 0
var dataFromTask2 = 0
var dataFromTask3 = 0
var dataFromTask4 = 0

Ax.serial(
  tasks: [
    { done in
      self.runAsync(afterSeconds: 2) {
        dataFromTask1 = 1
        done(nil)
      }
    },
    { done in
      self.runAsync(afterSeconds: 2) {
        dataFromTask2 = 2
        done(nil)
      }
    },
    { done in
      self.runAsync(afterSeconds: 2) {
        dataFromTask3 = 3
        done(nil)
      }
    },
    { done in
      self.runAsync(afterSeconds: 2) {
        dataFromTask4 = 4
        done(nil)
      }
    }
  ],
  result: { error in // feedback closure
    print(dataFromTask1)  // outputs 1
    print(dataFromTask2)  // outputs 2
    print(dataFromTask3)  // outputs 3
    print(dataFromTask4)  // outputs 4
  }
)
```

###Important aspects to mention are:
- The variable `done` is a closure that accepts an `NSError?` value, when `done` is called with a `nil` that means that the task was run successfully and in other hand if `done` is called with a `NSError` value then all subsequents tasks are ignored and then immediately the `result` closure is executed with the `error` passed to the `done` variable.
- The **closures** in `tasks` and `result` are run in `DispatchQoS.QoSClass.background` mode, it is up to you if you, for example, want to call the result in the main thread.



##Supported Functions

Initially the supported functions are:
- Serial
- Parallel

###Serial
This function help you to make asynchronous calls in a sequence way, running them in an orderly fashion where the first call is run and after this is finished, the next call is run and so on.

Example:

```swift
import Ax

var authorId = ""
var authorBooks = [Book]()

Ax.serial(
  tasks: [
    { done in
      self.getAuthorBy(name: "J. K. Rowling") { error, author in
        guard let author = author else {
          done(NSError(domain: "AppDomain", code: 434, userInfo: [NSLocalizedDescriptionKey: "didn't get author"]))
          return
        }

        authorId = author.id
        done(error)
      }
    },
    { done in
      self.getBooksBy(authorId: authorId, completion: { (error, books: [Book]) in
        authorBooks = books
        done(error)
      })
    }
  ],
  result: { error in
    if let error = error {
      print(error)
      return
    }

    print(authorBooks) // [Book(name: "Harry Potter and the Philosopher\'s Stone"), Book(name: "Harry Potter and the Chamber of Secrets")]
  }
)
```

###Parallel
Helps you to make asynchronous calls in a parallel way, this function will help you when you have a number of fixed calls that you need to perform but it doesn't matter if they are run all of them at the same time.

Example:

```swift
import Ax

let userId = "1"
let profileImageURL = "https://unsplash.it/100"

var userFound: User?
var userImage: UIImage?

Ax.parallel(
  tasks: [
    { done in

      self.getUserBy(id: userId) { error, user in
        guard let user = user else {
          done(NSError(domain: "AppDomain", code: 434, userInfo: [NSLocalizedDescriptionKey: "No user found."]))
          return
        }

        userFound = user
        done(error)
      }
    },
    { done in

      self.getProfileImageBy(url: profileImageURL) { error, image in
        guard let image = image else {
          done(NSError(domain: "AppDomain", code: 435, userInfo: [NSLocalizedDescriptionKey: "Image not found."]))
          return
        }

        userImage = image
        done(error)
      }
    }
  ],
  result: { error in
    if let error = error {
      print(error)
      return
    }

    print(userFound!) // User(name: "Walter While")
    print(userImage!) // <UIImage: 0x618000095a90>, {100, 100}
  }
)
```

## Installation

Ax is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Ax"
```

## Usage

Once installed just import it in your file that you are working:

`import Ax`

## Author

Wilson Balderrama, wilson.balderrama@gmail.com

## License

Ax is available under the MIT license. See the LICENSE file for more info.
