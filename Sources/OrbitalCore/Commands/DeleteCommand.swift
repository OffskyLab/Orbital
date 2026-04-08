import ArgumentParser
import Foundation

public struct DeleteCommand: ParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "delete",
        abstract: "Delete an orbital environment"
    )

    @Argument(help: "Name of the environment to delete")
    public var name: String

    @Flag(name: .long, help: "Skip confirmation prompt")
    public var force: Bool = false

    public init() {}

    public func run() throws {
        if !force {
            print("Delete environment '\(name)'? This cannot be undone. [y/N] ", terminator: "")
            let input = readLine()?.lowercased().trimmingCharacters(in: .whitespaces)
            guard input == "y" || input == "yes" else {
                print("Aborted.")
                return
            }
        }
        let store = EnvironmentStore.default
        try Self.deleteEnvironment(name: name, force: force, store: store)
        print("Deleted environment: \(name)")
    }

    public static func deleteEnvironment(name: String, force: Bool, store: EnvironmentStore) throws {
        try store.delete(named: name)
    }
}
