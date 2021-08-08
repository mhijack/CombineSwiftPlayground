import UIKit
import Foundation
import Combine

/*:
 # Publishers and Subscribers
 - A Publisher _publishes_ values ...
 - .. a subscriber _subscribes_ to receive publisher's values

 __Specifics__:
 - Publishers are _typed_ to the data and error types they can emit
 - A publisher can emit, zero, one or more values and terminate gracefully or with an error of the type it declared.
 */

/*:
## Example 1
"publish" just one value then complete
 */
let publisher1 = Just(42)

// You need to _subscribe_ to receive values (here using a sink with a closure)
let subscription1 = publisher1.sink { value in
	print("Received value from publisher1: \(value)")
}

/*:
## Example 2
"publish" a series of values immediately
 */
let publisher2 = [1,2,3,4,5].publisher

let subscription2 = publisher2
    .sink { value in
        print("Received value from publisher2: \(value)")
    }


/*:
## Example 3
assign publisher values to a property on an object
 */
print("")
class MyClass {
	var property: Int = 0 {
		didSet {
			print("Did set property to \(property)")
		}
	}
}

let object = MyClass()
let subscription3 = publisher2.assign(to: \.property, on: object)

//: [Next](@next)

//publisher1.sink { complete in
//
//} receiveValue: { <#Int#> in
//    <#code#>
//}

let justPublisher = Just("Combine")
let justSubscription = justPublisher.sink { complete in
    // Subscription is now complete
} receiveValue: { value in
    print(value)
}

// "Combine"


struct APIError: Error {
    
    enum type {
        case generic
    }
    
    init(_ type: type) {
        
    }
    
}

final class AuthManager {
  public func login(_ complete: (String?) -> Void) {
    // Hits our server authentication endpoint and carries back the access_token if authentication is successful, or nil if authentication failed.
//    complete("haha")
    complete(nil)
  }
}

let futurePublisher = Future<String, Error> { promise in
    AuthManager().login { accessToken in
        if let accessToken = accessToken {
            // A successful promise resolves to a single value
            promise(.success(accessToken))
        } else {
            // A failed promise resolves to an error of the type you specify
            promise(.failure(APIError(.generic)))
        }
    }
}

///
let futureSubscriber = futurePublisher.sink { complete in
    print(complete)
} receiveValue: { token in
    print(token)
}


class User: NSObject {
    var disposables = Set<AnyCancellable>()
    @Published var name: String
    
    init(name: String) {
        self.name = name
        super.init()
    }
}

let user = User(name: "Jack")
let namePublisher = user.$name
let nameSubscriber = namePublisher.sink { name in
    print(name)
}
// .store is instance method from Combine to store
nameSubscriber.store(in: &user.disposables)

user.name = "Melody"
// "Melody"
user.name = "Jason"
// "Jason"

nameSubscriber.cancel()

user.name = "Jack"
// nothing happens because the subscriber is manually canceled

let nameLabel = UILabel()
["jack", "melody", "jason"].publisher.assign(to: \.text, on: nameLabel)
// nameLabel will be set to "jack" "melody" and "jason" accordingly


