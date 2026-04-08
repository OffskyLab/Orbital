import ArgumentParser
public struct WhichCommand: ParsableCommand {
    public static let configuration = CommandConfiguration(commandName: "which", abstract: "Print config dir path for a tool")
    public init() {}
    public func run() throws { print("TODO") }
}
