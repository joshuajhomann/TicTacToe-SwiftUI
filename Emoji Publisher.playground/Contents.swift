import SwiftUI
import Combine


// Publisher
// Emits 0 to ♾️ Outputs followed by exactly 0 or 1 completion or Failure
// Subscriptions (sink and assign) return a Cancellable that you must retain to keep the Publisher alive

//Factories
let a = Just(1)
let b = Empty(completeImmediately: false, outputType: String.self, failureType: Never.self)
let c = Fail<Int, URLError>(error: URLError(URLError.Code(rawValue: 404)))

// Closure
let d = Future<Int, Never> { promise in
  promise(.success(1))
}

// Subject
class A {
  @Published var a = 0
}
let e = CurrentValueSubject<Int, Never>(0)
let f = PassthroughSubject<Int, Never>()

// Foundation (or RealityKit)
let g = NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)
let h = URLSession.shared.dataTaskPublisher(for: URL(string: "cnn.com")!)
let i = [1,2,3].publisher
let j = Timer.publish(every: 1, on: .main, in: .common)


let emojis = "🐶🐱🐭🐹🐰🦊🐻🐼🐨🐯"

let cancellable = Timer
  .publish(every: 1, on: .main, in: .common)
  .autoconnect()
  .map { _ in 1 }
  .scan (0, +)
  .prepend(0)
  .map { index in
    let wrappedIndex = index % emojis.count
    return String(emojis[emojis.index(emojis.startIndex, offsetBy: wrappedIndex)])
  }
  .sink { output in
    print(output)
  }








