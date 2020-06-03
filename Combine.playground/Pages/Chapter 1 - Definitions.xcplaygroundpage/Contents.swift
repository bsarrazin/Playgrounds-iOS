import Foundation

/// There are 4 main types to Combine:
/// 1. Publishers emit 0 or more values
///     a) output type; until stream is completed
///     b) successful event; completes the stream
///     c) failure event; completes the stream
/// 2. Operators are methods that act on values and return new values
/// 3. Subscribers use the final output or completion events to "do something", there are 2 built-in subscribers:
///     a) `sink` to provide a closure to receive output values and completions
///     b) `assign` to bind the resulting output to some property or UI control
/// 4. Subscriptions
///     a) adding a subscriber _activates_ the publisher
///     b) is `Cancellable `
///     c) can be sored in `[AnyCancellable]`

example(of: "foo") { print("bar") }
