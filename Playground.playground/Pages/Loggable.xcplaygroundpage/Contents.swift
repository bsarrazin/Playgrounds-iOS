/*:
 This example is based on a lecture given by Krzysztof Zabłocki
 Instead of accessing a logger as a singleton you create a protocol extension.
 
 Now we don't have to inject a Logger into every class that needs logging.
 Logging is a cross-cutting concern not a volatile dependency.
 */

import Foundation

enum LogLevel: Int, CustomStringConvertible {
    case error
    case warning
    case info
    case debug
    case verbose
    var description: String {
        switch self {
        case .error: return "Error"
        case .warning: return "Warning"
        case .info: return "Info"
        case .debug: return "Debug"
        case .verbose: return "Verbose"
        }
    }
}

enum LogTag: String {
    case `default` = "[Default]"
    case metrics = "[Metrics]"
    case networking = "[Networking]"
    case persistence = "[Persistence]"
    case userInterface = "[UserInterface]"
}

extension LogTag {
    static var all: [LogTag] {
        return [.default, .metrics, .networking, .persistence, .userInterface]
    }
}

struct LogConfiguration {
    let maxLevel: LogLevel
    let tags: [LogTag]
    let fileURL: URL?
}

protocol Loggable { var logConfig: LogConfiguration { get } }
extension Loggable {
    func logDebug(_ message: @autoclosure () -> Any, tag: LogTag = .default, halt: Bool? = nil, _ path: String = #file, _ function: String = #function, _ line: Int = #line) {
        log(message, level: .debug, tag: tag, halt: halt, path, function, line)
    }
    func logError(_ message: @autoclosure () -> Any, tag: LogTag = .default, halt: Bool? = nil, _ path: String = #file, _ function: String = #function, _ line: Int = #line) {
        log(message, level: .error, tag: tag, halt: halt, path, function, line)
    }
    func logInfo(_ message: @autoclosure () -> Any, tag: LogTag = .default, halt: Bool? = nil, _ path: String = #file, _ function: String = #function, _ line: Int = #line) {
        log(message, level: .info, tag: tag, halt: halt, path, function, line)
    }
    func logVerbose(_ message: @autoclosure () -> Any, tag: LogTag = .default, halt: Bool? = nil, _ path: String = #file, _ function: String = #function, _ line: Int = #line) {
        log(message, level: .verbose, tag: tag, halt: halt, path, function, line)
    }
    func logWarning(_ message: @autoclosure () -> Any, tag: LogTag = .default, halt: Bool? = nil, _ path: String = #file, _ function: String = #function, _ line: Int = #line) {
        log(message, level: .warning, tag: tag, halt: halt, path, function, line)
    }
    
    private func log(_ message: @autoclosure () -> Any, level: LogLevel, tag: LogTag, halt: Bool?, _ path: String = #file, _ function: String = #function, _ line: Int = #line) {
        guard level.rawValue <= self.logConfig.maxLevel.rawValue else { return }
        guard self.logConfig.tags.contains(tag) else { return }
        let file = path.split(separator: "/").last ?? ""
        print("\(file) -> \(function):\(line) [\(level.description)] \(message())")
    }
}

extension Loggable {
    var logConfig: LogConfiguration {
        return LogConfiguration(maxLevel: .warning, tags: LogTag.all, fileURL: nil)
    }
}

//: Now, you just implement Loggable on the classes that need logging...

class MyClass: Loggable {
    func logSomething() {
        logDebug("[\(type(of: self))] This is a networking debug message", tag: .networking)
        logWarning("[\(type(of: self))] This is a networking warning message", tag: .networking)
        logError("[\(type(of: self))] This is a metrics error message", tag: .metrics)
        logInfo("[\(type(of: self))] This is a peristence info message", tag: .persistence)
        logWarning("[\(type(of: self))] This is a user interface warning message", tag: .userInterface)
        logVerbose("[\(type(of: self))] This is a default verbose message")
    }
}
MyClass().logSomething()

class YourClass: Loggable {
    var logConfig: LogConfiguration {
        return LogConfiguration(maxLevel: .verbose, tags: LogTag.all, fileURL: nil)
    }
    func logSomething() {
        logDebug("[\(type(of: self))] This is a networking debug message", tag: .networking)
        logWarning("[\(type(of: self))] This is a networking warning message", tag: .networking)
        logError("[\(type(of: self))] This is a metrics error message", tag: .metrics)
        logInfo("[\(type(of: self))] This is a peristence info message", tag: .persistence)
        logWarning("[\(type(of: self))] This is a user interface warning message", tag: .userInterface)
        logVerbose("[\(type(of: self))] This is a default verbose message")
    }
}
YourClass().logSomething()


