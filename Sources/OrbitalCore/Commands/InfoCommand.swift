import ArgumentParser
public struct InfoCommand: ParsableCommand {
    public static let configuration = CommandConfiguration(commandName: "info", abstract: "Show environment details")
    public init() {}
    public func run() throws { print("TODO") }
}
