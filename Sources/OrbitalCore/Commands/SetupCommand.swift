import ArgumentParser
public struct SetupCommand: ParsableCommand {
    public static let configuration = CommandConfiguration(commandName: "setup", abstract: "Configure shell integration")
    public init() {}
    public func run() throws { print("TODO") }
}
