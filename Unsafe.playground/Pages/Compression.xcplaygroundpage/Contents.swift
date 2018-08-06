import Compression
import Foundation

enum CompressionAlgorithm {
    case lz4 // speed is critical
    case lz4a // space is critical
    case zlib // reasonable speed and space
    case lzfse // better speed and space
}

enum CompressionOperation {
    case compression
    case decompression
}

func perform(_ operation: CompressionOperation, on data: Data, using algorithm: CompressionAlgorithm, workingBufferSize: Int = 2000) -> Data? {
    let algo: compression_algorithm
    switch algorithm {
    case .lz4: algo = COMPRESSION_LZ4
    case .lz4a: algo = COMPRESSION_LZMA
    case .zlib: algo = COMPRESSION_ZLIB
    case .lzfse: algo = COMPRESSION_LZFSE
    }
    
    let op: compression_stream_operation
    let flags: Int32
    switch operation {
    case .compression:
        op = COMPRESSION_STREAM_ENCODE
        flags = Int32(COMPRESSION_STREAM_FINALIZE.rawValue)
    case .decompression:
        op = COMPRESSION_STREAM_DECODE
        flags = 0
    }
    
    var pointer = UnsafeMutablePointer<compression_stream>.allocate(capacity: 1)
    defer { pointer.deallocate() }
    
    var stream = pointer.pointee
    var status = compression_stream_init(&stream, op, algo)
    guard status != COMPRESSION_STATUS_ERROR
        else { return nil }
    
    defer { compression_stream_destroy(&stream) }
    
    let size = workingBufferSize
    let dstPointer = UnsafeMutablePointer<UInt8>.allocate(capacity: size)
    defer { dstPointer.deallocate() }
    
    return data.withUnsafeBytes { (srcPointer: UnsafePointer<UInt8>) in
        var output = Data()
        
        stream.src_ptr = srcPointer
        stream.src_size = data.count
        stream.dst_ptr = dstPointer
        stream.dst_size = size
        
        while status == COMPRESSION_STATUS_OK {
            status = compression_stream_process(&stream, flags)
            switch status {
            case COMPRESSION_STATUS_OK:
                output.append(dstPointer, count: size)
                stream.dst_ptr = dstPointer
                stream.dst_size = size
                
            case COMPRESSION_STATUS_ERROR:
                return nil
                
            case COMPRESSION_STATUS_END:
                output.append(dstPointer, count: stream.dst_ptr - dstPointer)
                
            default: fatalError()
            }
        }
        
        return output
    }
    
}

struct Compressed {
    var data: Data
    var algorithm: CompressionAlgorithm
    
    static func compress(data: Data, with algorithm: CompressionAlgorithm) -> Compressed? {
        guard let data = perform(.compression, on: data, using: algorithm)
            else { return nil }
        return Compressed(data: data, algorithm: algorithm)
    }
    
    func decompressed() -> Data? {
        return perform(.decompression, on: data, using: algorithm)
    }
}

extension Data {
    func compressed(with algorithm: CompressionAlgorithm) -> Compressed? {
        return Compressed.compress(data: self, with: algorithm)
    }
}

let input = Data(bytes: Array(repeating: UInt8(123), count: 10_000))
let compressed = input.compressed(with: .lzfse)
compressed?.data.count // should be less

let restored = compressed?.decompressed()
input == restored
