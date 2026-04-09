import ArgumentParser
import Foundation

public struct MCPSetupCommand: ParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "mcp",
        abstract: L10n.MCPSetup.abstract,
        subcommands: [SetupSubcommand.self],
        defaultSubcommand: SetupSubcommand.self
    )

    public init() {}

    public struct SetupSubcommand: ParsableCommand {
        public static let configuration = CommandConfiguration(
            commandName: "setup",
            abstract: L10n.MCPSetup.setupAbstract
        )

        public init() {}

        public func run() throws {
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
            process.arguments = ["claude", "mcp", "add", "--scope", "project", "orbital", "--", "orbital", "mcp-server"]
            process.standardInput = FileHandle.standardInput
            process.standardOutput = FileHandle.standardOutput
            process.standardError = FileHandle.standardError

            try process.run()
            process.waitUntilExit()

            if process.terminationStatus == 0 {
                print(L10n.MCPSetup.success)
            } else {
                throw ExitCode(process.terminationStatus)
            }
        }
    }
}
