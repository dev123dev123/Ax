# Ax

[![CI Status](http://img.shields.io/travis/Wilson Balderrama/Ax.svg?style=flat)](https://travis-ci.org/Wilson Balderrama/Ax)
[![Version](https://img.shields.io/cocoapods/v/Ax.svg?style=flat)](http://cocoapods.org/pods/Ax)
[![License](https://img.shields.io/cocoapods/l/Ax.svg?style=flat)](http://cocoapods.org/pods/Ax)
[![Platform](https://img.shields.io/cocoapods/p/Ax.svg?style=flat)](http://cocoapods.org/pods/Ax)

![Ax](ax-logo.png)

Ax is a library written in Swift that helps you to control the flow of asynchronous executions in a simplified way .

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

```swift
Ax.serial(
	tasks: [
		{ done in
			server.getPost(by: "postid", completion: { error, post in
			  // call done with nil argument value
			  // if there isn't any error
			  // otherwise call it with an error
			  done(nil)
			})
		},
		{ done in
		    server.getUser(by: "userid", completion: { error, user in
			  done(nil)
		    })
		}
	],
	result: { error in

	}
)
```

## Requirements

## Installation

Ax is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Ax"
```

## Author

Wilson Balderrama, wilson.balderrama@gmail.com

## License

Ax is available under the MIT license. See the LICENSE file for more info.
