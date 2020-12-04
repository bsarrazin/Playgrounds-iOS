import Foundation

MemoryLayout<Int>.size
MemoryLayout<Int>.alignment
MemoryLayout<Int>.stride

MemoryLayout<Int16>.size
MemoryLayout<Int16>.alignment
MemoryLayout<Int16>.stride

MemoryLayout<Bool>.size
MemoryLayout<Bool>.alignment
MemoryLayout<Bool>.stride

MemoryLayout<Float>.size
MemoryLayout<Float>.alignment
MemoryLayout<Float>.stride

MemoryLayout<Double>.size
MemoryLayout<Double>.alignment
MemoryLayout<Double>.stride

struct EmptyStruct { }
MemoryLayout<EmptyStruct>.size
MemoryLayout<EmptyStruct>.alignment
MemoryLayout<EmptyStruct>.stride

struct SampleStruct {
    let number: UInt32
    let flag: Bool
}
MemoryLayout<SampleStruct>.size
MemoryLayout<SampleStruct>.alignment
MemoryLayout<SampleStruct>.stride

class EmptyClass { }
MemoryLayout<EmptyClass>.size
MemoryLayout<EmptyClass>.alignment
MemoryLayout<EmptyClass>.stride

class SampleClass {
    let number: Int64 = 0
    let flag: Bool = false
}
MemoryLayout<SampleClass>.size
MemoryLayout<SampleClass>.alignment
MemoryLayout<SampleClass>.stride

do {
    var sample = SampleStruct(number: 25, flag: true)
    withUnsafeBytes(of: &sample) { raw in
        raw.forEach { print($0) }
    }
}

do {
    print("Checksum the bytes of a struct")
    var sample = SampleStruct(number: 25, flag: true)
    let checksum = withUnsafeBytes(of: &sample) { (raw) -> UInt32 in
        return ~raw.reduce(UInt32(0)) { $0 + numericCast($1) }
    }
    
    print("checksum: ", checksum)
}
