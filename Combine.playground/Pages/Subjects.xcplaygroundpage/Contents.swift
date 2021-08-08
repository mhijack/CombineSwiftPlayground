//: [Previous](@previous)
import Foundation
import Combine
import UIKit
/*:
# Subjects
- A subject is a publisher ...
- ... relays values it receives from other publishers ...
- ... can be manually fed with new values
- ... subjects as also subscribers, and can be used with `subscribe(_:)`
*/

/*:
## Example 1
Using a subject to relay values to subscribers
*/
let relay = PassthroughSubject<String, Never>()

let subscription = relay
    .sink { value in
        print("subscription1 received value: \(value)")
}

relay.send("Hello")
relay.send("World!")


let passthrough = PassthroughSubject<Int, Never>()
let passthroughSubscription = passthrough.sink { value in
    print(value)
}
passthrough.send(0)
passthrough.send(10)

// 0
// 10


//: What happens if you send "hello" before setting up the subscription?
/// Nothing happens because the publisher wouldn't emit output if there's no subscription.

/*:
## Example 2
Subscribing a subject to a publisher
*/

let publisher = ["Here","we","go!"].publisher /// .publisher if a helper extension that turns values into a publisher and publishes the value immediately.

publisher.subscribe(relay)

/*:
## Example 3
Using a `CurrentValueSubject` to hold and relay the latest value to new subscribers
*/

let variable = CurrentValueSubject<String, Never>("")

//variable.send("Initial text")
///// .send() is called before subscription, and it publishes value. Unlike a PassThroughSubject
//
//
//
//variable.send("More text")
//: [Next](@next)


let subscription2 = variable.sink { value in
    print("subscription2 received value: \(value)")
}
//let subscription3 = variable.sink { value in
//    print("subscription3 received value: \(value)")
//}



let currentvalue = CurrentValueSubject<Int, Never>(0)
print(currentvalue.value) // prints: 0
currentvalue.value = 10
print(currentvalue.value) // prints: 10

let currentvalueSubscription = currentvalue.sink { value in
    print(value)
}
currentvalue.value = 99 // prints: 99
currentvalueSubscription.cancel()



print("pub=======")



class MapDemo {
    var text: String = "" {
        didSet {
            print(text)
        }
    }
}

let mapper = MapDemo()
let transformerSubscription = [1, 2, 3, 4, 5].publisher.map { value in
    return "Received value \(value)"
}.assign(to: \.text, on: mapper)



class LoginManager {
    var username: String = ""
    var password: String = ""
}

let loginManager = LoginManager()




class LoginViewController: UIViewController {
    @Published var username: String = ""
    @Published var password: String = ""
    
    let loginButton = UIButton()
    
    var disposables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}
