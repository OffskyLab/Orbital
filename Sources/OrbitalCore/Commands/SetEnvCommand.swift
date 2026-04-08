import ArgumentParser
public struct SetEnvCommand: ParsableCommand {
    public static let configuration = CommandConfiguration(commandName: "set", abstract: "Set configuration values")
    public init() {}
    public func run() throws { print("TODO") }
}
