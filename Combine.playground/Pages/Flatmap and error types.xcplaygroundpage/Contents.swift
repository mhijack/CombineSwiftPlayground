//: [Previous](@previous)

import Foundation
import UIKit
import Combine

/*:
 [Previous](@previous)
 ## flatmap
 - with `flatmap` you provide a new publisher every time you get a value from the upstream publisher
 - ... values all get _flattened_ into a single stream of values
 - ... it looks like Swift's `flatMap` where you flatten inner arrays of an array, just asynchronous.
 
 ## matching error types
 - use `mapError` to map a failure into a different error type
 */

//: define the error type we need
enum RequestError: Error {
    case sessionError(error: Error)
}

//: we will send URLs through this publisher to trigger requests
let URLPublisher = PassthroughSubject<URL, RequestError>()

//: use `flatMap` to turn a URL into a requested data publisher
let subscription = URLPublisher.flatMap { requestURL in
    URLSession.shared
        .dataTaskPublisher(for: requestURL)
        .mapError { error -> RequestError in
            RequestError.sessionError(error: error)
        }
}
.assertNoFailure()
.sink { result in
    print("Request completed!")
    _ = UIImage(data: result.data)
}

URLPublisher.send(URL(string: "https://httpbin.org/image/jpeg")!)
//: [Next](@next)

struct APIError: Error {
    
}

let subject = PassthroughSubject<Int, Error>()
subject
    .flatMap({ index -> URLSession.DataTaskPublisher in
        let url = URL(string: "https://example.org/get?index=\(index)")!
        return URLSession.shared.dataTaskPublisher(for: url)
    })
    .map({ result -> UIImage? in
        return UIImage(data: result.data)
    })
//    .replaceError(with: nil)
    .catch { error -> Just<UIImage?> in
        return Just(nil)
    }
    .sink { value in
        print(value)
    }



let notFoundImage: UIImage? = UIImage()
let imageURLPublisher = PassthroughSubject<URL, RequestError>()
let cancellable = imageURLPublisher.flatMap { requestURL in
    return URLSession.shared.dataTaskPublisher(for: requestURL)
        .mapError { error -> RequestError in
            return RequestError.sessionError(error: error)
        }
}.map({ (result) -> UIImage? in
    return UIImage(data: result.data)
}).catch({ (error) -> Just<UIImage?> in
    return Just(notFoundImage)
}).sink(receiveValue: { (image) in
    _ = image
})
