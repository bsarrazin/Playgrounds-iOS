import Foundation

struct Identifier<T>: RawRepresentable {
    var rawValue: String
}

extension Identifier {
    static var unique: Identifier<T> { .init(rawValue: "0") }
}

public class DataStore {
    func single<T>(_: T.Type, id: Identifier<T>) -> T? {
        return nil
    }
}

let ds = DataStore()
ds.single(Old.self, id: .unique)




let old = """
{
  "foo": "foo"
}
""".data(using: .utf8)!

let new = """
{
  "foo": "foo",
  "bar": 42
}
""".data(using: .utf8)!

struct Old: Codable {
    var foo: String
}

struct New: Codable {
    var foo: String
    var bar: Int = 0
}

let decoder = JSONDecoder()

try decoder.decode(Old.self, from: old)
try decoder.decode(Old.self, from: new)

try decoder.decode(New.self, from: old)
try decoder.decode(New.self, from: new)
