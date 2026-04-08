import ArgumentParser
public struct AddToolCommand: ParsableCommand {
    public static let configuration = CommandConfiguration(commandName: "add", abstract: "Add a tool to an environment")
    public init() {}
    public func run() throws { print("TODO") }
}
