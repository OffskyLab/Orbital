import ArgumentParser
import Foundation

public struct SetupCommand: ParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "setup",
        abstract: L10n.Setup.abstract
    )

    @Option(name: .long, help: ArgumentHelp(L10n.Setup.shellHelp))
    public var shell: String?

    public init() {}

    public func run() throws {
        let resolved = try Self.resolveShell(explicit: shell)
        let rcFile = Self.rcFile(for: resolved)
        Self.installShellIntegration(to: rcFile)

        // stdout: shell function for immediate eval in current shell
        print(ShellFunctionGenerator.generate())
    }

    static func resolveShell(explicit: String?) throws -> String {
        if let explicit {
            let lower = explicit.lowercased()
            guard lower == "bash" || lower == "zsh" else {
                throw ValidationError(L10n.Setup.unsupportedShell(explicit))
            }
            return lower
        }
        let shellPath = ProcessInfo.processInfo.environment["SHELL"] ?? "/bin/zsh"
        let name = URL(fileURLWithPath: shellPath).lastPathComponent
        switch name {
        case "bash": return "bash"
        case "zsh":  return "zsh"
        default:     return "zsh"
        }
    }

    static func rcFile(for shell: String) -> URL {
        let home = FileManager.default.homeDirectoryForCurrentUser
        switch shell {
        case "bash": return home.appendingPathComponent(".bashrc")
        default:     return home.appendingPathComponent(".zshrc")
        }
    }

    static func installShellIntegration(to url: URL) {
        let initLine = #"eval "$(orbital setup)""#
        var existing = ""
        if FileManager.default.fileExists(atPath: url.path) {
            existing = (try? String(contentsOf: url, encoding: .utf8)) ?? ""
        }
        guard !existing.contains(initLine) else {
            FileHandle.standardError.write(Data(L10n.Setup.alreadyPresent(url.path).utf8))
            return
        }
        let appended = existing + "\n# orbital shell integration\n\(initLine)\n"
        do {
            try appended.write(to: url, atomically: true, encoding: .utf8)
            FileHandle.standardError.write(Data(L10n.Setup.addedTo(url.path).utf8))
        } catch {
            FileHandle.standardError.write(Data(L10n.Setup.failedToWrite(url.path, error.localizedDescription).utf8))
        }
    }
}
