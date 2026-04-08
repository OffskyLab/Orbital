import ArgumentParser
public struct DeleteCommand: ParsableCommand {
    public static let configuration = CommandConfiguration(commandName: "delete", abstract: "Delete an environment")
    public init() {}
    public func run() throws { print("TODO") }
}
