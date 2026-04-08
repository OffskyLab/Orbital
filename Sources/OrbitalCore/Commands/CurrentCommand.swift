import ArgumentParser
public struct CurrentCommand: ParsableCommand {
    public static let configuration = CommandConfiguration(commandName: "current", abstract: "Print active environment name")
    public init() {}
    public func run() throws { print("TODO") }
}
