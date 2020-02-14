import Foundation

[1, 2, 3]
    .map(String.init)
    .joined(separator: ".")

struct SemanticVersion {
    var major: UInt
    var minor: UInt
    var patch: UInt

    init(_ major: UInt, _ minor: UInt, _ patch: UInt) {
        self.major = major
        self.minor = minor
        self.patch = patch
    }
}

extension Bundle {
    var version: String { "1.1.0" }
    var semanticVersion: SemanticVersion? {
        let components = version
            .components(separatedBy: ".")
            .compactMap(UInt.init)

        guard components.count == 3 else { return nil }

        return SemanticVersion(components[0], components[1], components[2])
    }
}

let u: UInt = -2

// ThreadSafeStore<BinaryDataStore<MemoryDataStore>>
