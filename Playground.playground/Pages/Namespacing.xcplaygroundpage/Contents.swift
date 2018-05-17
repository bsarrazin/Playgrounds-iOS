//: [Previous](@previous)

import Foundation
import RxSwift
import UIKit

/// This protocol is _only_ used as a marking protocol.
/// Is _only_ used to implement extension where `ConcreteType` is equal to a real type
protocol DelineatingProtocol {
    associatedtype ConcreteType
}

// MARK: - Namespace

/// This is the concrete implementation of the namespace.
/// This is required in order to able to call `Type.namespace` and have it return an instance.
struct NamespaceImplementation<T> {
    private init() { }
}

/// This extensions 'forwards' the generic T to the protocol's associated type.
extension NamespaceImplementation: DelineatingProtocol {
    typealias ConcreteType = T
}

/// The name of the Namespace.
/// Used to define the name of the variable used as the namespace.
/// The associated type is used to identify on which type the namespace is available.
protocol Namespace {
    associatedtype TypeImplementingNamespace
    
    static var namespaceVariable: NamespaceImplementation<TypeImplementingNamespace>.Type { get }
}

/// This extension implements the default instance variable for the namespace
extension Namespace {
    static var namespaceVariable: NamespaceImplementation<Self>.Type {
        return NamespaceImplementation<Self>.self
    }
}

// MARK: - Namespace Types

/// This is the type of object that the namespace should return.
/// It can be anything we want (e.g. exceptions, behaviours, etc...)
struct NamespaceType: Error, Equatable, Decodable {
    let key: String
    let int: Int
}

/// A simple pattern matching method.
/// Allows to check...
///     switch namespaceTypeInstance { // concrete instance of exception or behavior, etc...
///     case namespaceTypeInstance as ConcreteType.namespace.foo:
///         // deal with foo
///     case namespaceTypeInstance asConcreteType.namespace.bar:
///         // deal with bar
///     }
func ~= (pattern: NamespaceType, value: Error) -> Bool {
    guard let value = value as? NamespaceType else { return false }
    return value == pattern
}

/* ~~~~~~~~~~ Playground In Action ~~~~~~~~~~ */

struct Foo {
    let bar: String
}

extension Foo: Namespace {}
extension DelineatingProtocol where ConcreteType == Foo {
    static var fooWorld: NamespaceType { return .init(key: #function, int: 401) }
}

Foo.namespaceVariable.fooWorld.key
Foo.namespaceVariable.fooWorld.int

struct Bar {
    let foo: Int
}

extension Bar: Namespace {}
extension DelineatingProtocol where ConcreteType == Bar {
    static var barWorld: NamespaceType { return .init(key: #function, int: 500) }
}

Bar.namespaceVariable.barWorld.key
Bar.namespaceVariable.barWorld.int
