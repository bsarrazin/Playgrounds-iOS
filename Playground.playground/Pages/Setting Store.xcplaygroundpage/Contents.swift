import Foundation
import PlaygroundSupport
import XCTest

class BinarySettingStoreTests: XCTestCase {
    
    func testErase() throws {
        let setting: Setting<Bool> = .init(key: "hello.world", default: true)
        let store = BinarySettingStore(name: "hello.world")
        try store.erase(item: setting)
    }
    
    func testLoad() throws {
        let setting: Setting<Bool> = .init(key: "hello.world", default: true)
        let store = BinarySettingStore(name: "hello.world")
        try store.load(item: setting)
    }
    
    func testSave() throws {
        let setting: Setting<Bool> = .init(key: "hello.world", default: true)
        let store = BinarySettingStore(name: "hello.world")
        try store.save(item: setting)
        
    }
    
}

BinarySettingStoreTests.defaultTestSuite.run()
print(playgroundSharedDataDirectory)

//public class BinarySettingStore {
//
//    let name: String
//
//    // MARK: - Private Properties
//    private let fileManager: FileManager
//    private let queue = DispatchQueue(label: "SettingStoreContainer.queue")
//
//    // MARK: - Lifecycle
//    public init(name: String, fileManager: FileManager = .default) {
//        self.name = name
//        self.fileManager = fileManager
//    }
//
//    // MARK: - Item Overrides
//    func loadItems<T: Codable>() throws -> [T] {
//        let data = try Data(contentsOf: dataPath("Settings"))
//        return try PropertyListDecoder().decode([T].self, from: data)
//    }
//
//    // MARK: - FileSystem Functions
//    func dataDirectory() -> URL {
//        let directory = fileManager
//            .urls(for: .applicationSupportDirectory, in: .userDomainMask)
//            .first?
//            .appendingPathComponent(name)
//
//        guard
//            let dataDirectory = directory,
//            let _ = try? fileManager.createDirectory(at: dataDirectory,
//                                                     withIntermediateDirectories: true,
//                                                     attributes: nil)
//            else { fatalError("Unable to create path to data") }
//
//        return dataDirectory
//    }
//    func dataPath(_ type: String) -> URL {
//        return dataDirectory()
//            .appendingPathComponent(type, isDirectory: false)
//            .appendingPathExtension("plist")
//    }
//}
//
//
//
//
//let plist = """
//<?xml version="1.0" encoding="UTF-8"?>
//<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
//<plist version="1.0">
//    <array>
//        <dict>
//            <key>string</key>
//            <string>HelloWorld</string>
//            <key>int</key>
//            <integer>42</integer>
//        </dict>
//    </array>
//</plist>
//"""
//
//let data = plist.data(using: .utf8)!
//let foo = try! PropertyListDecoder().decode(<<what goes here?>>, from: data)
//
//
//print("yes")
