import ArgumentParser
public struct InitCommand: ParsableCommand {
    public static let configuration = CommandConfiguration(commandName: "init", abstract: "Output shell integration script")
    public init() {}
    public func run() throws { print("TODO") }
}
