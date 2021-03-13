import Combine
import Foundation
import UIKit

enum Foo {
    case foo, bar, baz
}

struct Bar {
    var foo: Foo?
}

let null = Bar(foo: nil)
let foo = Bar(foo: .foo)
let bar = Bar(foo: .bar)
let baz = Bar(foo: .baz)


switch null.foo {
case .foo?, .bar?: print(true)
default: print(false)
}

switch foo.foo {
case .foo?, .bar?: print(true)
default: print(false)
}

switch bar.foo {
case .foo?, .bar?: print(true)
default: print(false)
}

switch baz.foo {
case .foo?, .bar?: print(true)
default: print(false)
}
