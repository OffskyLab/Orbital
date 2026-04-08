import ArgumentParser
public struct CreateCommand: ParsableCommand {
    public static let configuration = CommandConfiguration(commandName: "create", abstract: "Create a new environment")
    public init() {}
    public func run() throws { print("TODO") }
}
