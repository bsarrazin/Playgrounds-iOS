import Foundation

enum RandomSource {
    static let file = fopen("/dev/urandom", "r")
    static let queue = DispatchQueue(label: "random")
    
    static func get(count: Int) -> [Int8] {
        let capacity = count + 1
        var data = UnsafeMutablePointer<Int8>.allocate(capacity: capacity)
        defer { data.deallocate() }
        
        queue.sync {
            fgets(data, Int32(capacity), file)
        }
        
        return Array(UnsafeMutableBufferPointer(start: data, count: count))
    }
}

extension Integer {
    static var randomized: Self {
        let numbers = RandomSource.get(count: MemoryLayout<Self>.size)
        
    }
}
