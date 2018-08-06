import Foundation

let count = 2
let stride = MemoryLayout<Int>.stride
let alignment = MemoryLayout<Int>.alignment
let byteCount = stride * count

do {
    print("Raw Pointers")
    
    let pointer = UnsafeMutableRawPointer.allocate(byteCount: byteCount, alignment: alignment)
    defer { pointer.deallocate() }
    
    pointer.storeBytes(of: 42, as: Int.self)
    pointer.advanced(by: stride).storeBytes(of: 6, as: Int.self)
    pointer.load(as: Int.self)
    pointer.advanced(by: stride).load(as: Int.self)
    
    let buffer = UnsafeRawBufferPointer(start: pointer, count: byteCount)
    for (index, byte) in buffer.enumerated() {
        print("byte: \(index): \(byte)")
    }
}

do {
    print("Typed Pointers")
    
    let pointer = UnsafeMutablePointer<Int>.allocate(capacity: count)
    pointer.initialize(to: 0)
    defer {
        pointer.deinitialize(count: count)
        pointer.deallocate()
    }
    
    pointer.pointee = 42
    pointer.advanced(by: 1).pointee = 6
    pointer.pointee
    pointer.advanced(by: 1).pointee
    
    let buffer = UnsafeBufferPointer(start: pointer, count: count)
    for (index, value) in buffer.enumerated() {
        print("value \(index): \(value)")
    }
}

do {
    print("Converting raw pointers to typed pointers")
    
    let raw = UnsafeMutableRawPointer.allocate(byteCount: byteCount, alignment: alignment)
    defer { raw.deallocate() }
    
    let typed = raw.bindMemory(to: Int.self, capacity: count)
    typed.initialize(to: 0)
    defer { typed.deinitialize(count: count) }
    
    typed.pointee = 42
    typed.advanced(by: 1).pointee = 6
    typed.pointee
    typed.advanced(by: 1).pointee
    
    let buffer = UnsafeBufferPointer(start: typed, count: count)
    for (index, value) in buffer.enumerated() {
        print("value \(index): \(value)")
    }
}
