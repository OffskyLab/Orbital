import Foundation
#if canImport(Darwin)
import Darwin
#else
import Glibc
#endif

public struct ToolSetup {

    public enum SetupError: Error {
        case installFailed(String)
        case authFailed(String)
    }

    /// Run the full setup flow for a tool: check install → offer install → offer auth.
    /// Credentials are stored in configDir (the orbital env's tool subdirectory).
    public static func setup(_ tool: Tool, configDir: URL, envName: String) throws {
        guard tool.supportsSetup else { return }

        print("")

        // ── 1. Check & install ──────────────────────────────────────────
        if !isInstalled(tool) {
            print(L10n.ToolSetup.notInstalled(tool.rawValue))
            print(L10n.ToolSetup.installNow, terminator: "")
            fflush(stdout)
            let input = readLine()?.lowercased().trimmingCharacters(in: .whitespaces) ?? ""
            guard input.isEmpty || input == "y" || input == "yes" else {
                print(L10n.ToolSetup.skipping(tool.rawValue))
                return
            }
            try install(tool)
        }

        // ── 2. Print login instructions ─────────────────────────────────
        if let cmd = tool.authCommand {
            print(L10n.ToolSetup.loginInstructions(tool.rawValue, envName, cmd.joined(separator: " ")))
        }
    }

    // MARK: - Internal

    static func isInstalled(_ tool: Tool) -> Bool {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/which")
        process.arguments = [tool.rawValue]
        process.standardOutput = FileHandle.nullDevice
        process.standardError = FileHandle.nullDevice
        try? process.run()
        process.waitUntilExit()
        return process.terminationStatus == 0
    }

    static func install(_ tool: Tool) throws {
        guard let cmd = tool.installCommand else { return }

        enterAlternateScreen()
        print(L10n.ToolSetup.installing(tool.rawValue, cmd.joined(separator: " ")))
        fflush(stdout)

        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.arguments = cmd
        try process.run()
        process.waitUntilExit()

        exitAlternateScreen()

        guard process.terminationStatus == 0 else {
            throw SetupError.installFailed(tool.rawValue)
        }
        print(L10n.ToolSetup.installed(tool.rawValue))
    }

    static func authenticate(_ tool: Tool, configDir: URL) throws {
        guard let cmd = tool.authCommand else { return }

        print(L10n.ToolSetup.running(cmd.joined(separator: " ")))
        print(L10n.ToolSetup.credentialsPath(configDir.path))
        fflush(stdout)

        // Set env var in current process so child inherits the full environment naturally.
        // Replacing process.environment entirely can strip vars claude/codex depend on.
        setenv(tool.envVarName, configDir.path, 1)
        defer { unsetenv(tool.envVarName) }

        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.arguments = cmd
        // No process.environment override — child inherits everything
        process.standardInput = FileHandle.standardInput
        process.standardOutput = FileHandle.standardOutput
        process.standardError = FileHandle.standardError
        try process.run()
        process.waitUntilExit()

        if process.terminationStatus == 0 {
            print(L10n.ToolSetup.loginComplete(tool.rawValue))
        } else {
            print(L10n.ToolSetup.loginFailed(tool.rawValue, process.terminationStatus, cmd.joined(separator: " ")))
        }
    }

    // MARK: - Terminal helpers

    private static func enterAlternateScreen() {
        print("\u{1B}[?1049h", terminator: "")
        fflush(stdout)
    }

    private static func exitAlternateScreen() {
        print("\u{1B}[?1049l", terminator: "")
        fflush(stdout)
    }
}
