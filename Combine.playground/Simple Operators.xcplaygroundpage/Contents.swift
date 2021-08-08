//: [Previous](@previous)

import Foundation
import Combine
/*:
 # Simple operators
 - Operators are functions defined on publisher instances...
 - ... each operator returns a new publisher ...
 - ... operators can be chained to add processing steps
 */

/*:
 ## Example: `map`
 - works like Swift's `map`
 - ... operates on values over time
 */
let publisher1 = PassthroughSubject<Int, Never>()

let publisher2 = publisher1.map { value in
    value + 100
}

let subscription1 = publisher1
    .sink { value in
        print("Subscription1 received integer: \(value)")
    }

let subscription2 = publisher2
    .sink { value in
        print("Subscription2 received integer: \(value)")
    }

print("* Demonstrating map operator")
print("Publisher1 emits 28")
publisher1.send(28)
/// Sub1 received integer 28
/// Sub2 received integer 28 + 100

print("Publisher1 emits 50")
publisher1.send(50)
/// Sub1 received integer 50
/// Sub2 received integer 50 + 100

subscription1.cancel()
subscription2.cancel()

/*:
 ## Example: `filter`
 - works like Swift's `filter`
 - ... operates on values over time
 */

let publisher3 = publisher1.filter {
    // only let even values pass through
    ($0 % 2) == 0
}

let subscription3 = publisher3
    .sink { value in
        print("Subscription3 received integer: \(value)")
    }

print("\n* Demonstrating filter operator")
print("Publisher1 emits 14")
publisher1.send(14) /// prints "14"

print("Publisher1 emits 15")
publisher1.send(15) /// Doesn't print

print("Publisher1 emits 16")
publisher1.send(16) /// prints "16"

//: [Next](@next)





let intList = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
intList.publisher
    .filter({ $0 % 2 == 0 })
    .map({ String("Received integer: \($0)") })
    .sink { result in
        print(result)
    }

// Received integer: 0
// Received integer: 2
// Received integer: 4
// Received integer: 6
// Received integer: 8




[0, 1, 1].publisher
    .removeDuplicates()
    .sink { value in
        print(value)
    }

// 0
// 1

[0, 1, 0, 1].publisher
    .removeDuplicates()
    .sink { value in
        print(value)
    }

// 0
// 1
// 0
// 1
//
//
//let mapper = MapDemo()
//let transformerSubscription = [1, 2, 3, 4, 5].publisher
//    .map { value in
//        return "Received value \(value)"
//    }.assign(to: \.text, on: mapper)





print("==================")

let integerConvertSubject = PassthroughSubject<String, Never>()
let integerConvertSubscription = integerConvertSubject
    .compactMap({ value in
        return Int(value)
    })
    .sink { value in
        print("value came out of compact map: \(value)")
    }

integerConvertSubject.send("a")
integerConvertSubject.send("q")
integerConvertSubject.send("e")
integerConvertSubject.send("t")
integerConvertSubject.send("p")
integerConvertSubject.send("1")
integerConvertSubject.send("100")

// "value came out of compact map: 1"
// "value came out of compact map: 100"



class LoginViewModel {
    public var username = CurrentValueSubject<String, Never>("")
    public var password = CurrentValueSubject<String, Never>("")
    public var confirmPassword = CurrentValueSubject<String, Never>("")
    
    public var isValid = false
}

let loginViewModel = LoginViewModel()
Publishers
    .CombineLatest3(loginViewModel.username, loginViewModel.password, loginViewModel.confirmPassword)
    .map { (username, password, confirmPassword) in
        return username 
    }
