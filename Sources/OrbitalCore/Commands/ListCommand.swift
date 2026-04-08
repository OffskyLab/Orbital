import ArgumentParser
public struct ListCommand: ParsableCommand {
    public static let configuration = CommandConfiguration(commandName: "list", abstract: "List all environments")
    public init() {}
    public func run() throws { print("TODO") }
}
