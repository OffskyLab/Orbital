import ArgumentParser
public struct RemoveToolCommand: ParsableCommand {
    public static let configuration = CommandConfiguration(commandName: "remove", abstract: "Remove a tool from an environment")
    public init() {}
    public func run() throws { print("TODO") }
}
