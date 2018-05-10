
import Foundation

// Lenses provide a managed (and semantically clear) way to handle updates to immutable
// objects. They allow you to change a value held by an immutable object by creating a copy
// of the object containing the updated data.
//
// - Scala Design Patterns

// A lens is simply the combination of a getter (e.g. getting the address out of a person)
// and a setter (a function that, given a person and a changed address, creates a new person
// value with the updated address).
//
// http://chris.eidhof.nl/post/lenses-in-swift/


struct Lens<A,B> {
    let from : (A) -> B
    let to : (B, A) -> A
}

struct Address {
    let street : String
    let city : String
}

let street : Lens<Address,String> = Lens(from: { $0.street }, to: {
    Address(street: $0, city: $1.city)
})

let city: Lens<Address, String> = Lens(from: { $0.city }, to: {
    Address(street: $1.street, city: $0)
})

let existingAddress = Address(street: "Apple Cres.", city: "Ottawa")
let newAddress = street.to("My new street name", existingAddress)
let differentCityAddress = city.to("Montreal", newAddress)

print(existingAddress)
print(newAddress)
print(differentCityAddress)
print(street.from(newAddress))

