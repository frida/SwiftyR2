import Foundation
import Radare2

public struct R2LogEntry: Sendable {
    public let level: R2LogLevel
    public let origin: String?
    public let message: String

    public init(level: R2LogLevel, origin: String?, message: String) {
        self.level = level
        self.origin = origin
        self.message = message
    }
}

public enum R2LogLevel: Int, Sendable {
    case fatal = 0
    case error = 1
    case info = 2
    case warn = 3
    case todo = 4
    case debug = 5
    case trace = 6

    init(_ raw: Int32) {
        self = R2LogLevel(rawValue: Int(raw)) ?? .info
    }
}

final class R2LogCollector {
    var entries: [R2LogEntry] = []
    var ownerThread: Thread?
}

let r2LogCallback: RLogCallback = { user, type, origin, msg in
    let collector = Unmanaged<R2LogCollector>.fromOpaque(user!).takeUnretainedValue()
    guard collector.ownerThread === Thread.current else { return true }
    let originStr = origin.map { String(cString: $0) }
    let message = msg.map { String(cString: $0) } ?? ""
    collector.entries.append(
        R2LogEntry(level: R2LogLevel(type), origin: originStr, message: message)
    )
    return true
}
