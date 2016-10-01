# Ax

![Ax](ax-logo.png)

Ax is a library written in Swift that helps you to control the flow of asynchronous executions in a simplified way .

##Usage

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

##Installation

##Features

##Author
Wilson Balderrama, [wilson.balderrama@gmail.com](wilson.balderrama@gmail.com)

##License
**Ax** is released under the MIT license. See **LICENSE** file for details.
