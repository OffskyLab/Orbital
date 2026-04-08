import ArgumentParser
public struct ExportCommand: ParsableCommand {
    public static let configuration = CommandConfiguration(commandName: "_export", abstract: "Internal: print export lines")
    public init() {}
    public func run() throws { print("TODO") }
}
