import Foundation

public struct R2CommandResult: Sendable {
    public let output: String
    public let logs: [R2LogEntry]

    public var errors: [R2LogEntry] {
        logs.filter { $0.level == .fatal || $0.level == .error }
    }

    public var hasErrors: Bool {
        logs.contains { $0.level == .fatal || $0.level == .error }
    }

    public init(output: String, logs: [R2LogEntry]) {
        self.output = output
        self.logs = logs
    }
}
