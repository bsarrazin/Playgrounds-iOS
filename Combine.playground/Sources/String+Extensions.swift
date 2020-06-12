import CryptoKit
import Foundation

private protocol ByteCountable {
    static var byteCount: Int { get }
}

extension Insecure.MD5: ByteCountable { }
extension Insecure.SHA1: ByteCountable { }

extension String {
    public func md5(using encoding: String.Encoding = .utf8) -> String {
        return self.hash(algo: Insecure.MD5.self, using: encoding)
    }

    public func sha1(using encoding: String.Encoding = .utf8) -> String {
        return self.hash(algo: Insecure.SHA1.self, using: encoding)
    }

    private func hash<Hash: HashFunction & ByteCountable>(algo: Hash.Type, using encoding: String.Encoding = .utf8) -> String {
        return algo
            .hash(data: data(using: encoding)!)
            .prefix(algo.byteCount)
            .map { String(format: "%02hhx", $0) }
            .joined()
    }
}
