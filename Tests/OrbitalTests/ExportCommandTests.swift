import Testing
import Foundation
@testable import OrbitalCore

@Suite("ExportCommand")
struct ExportCommandTests {
    var tmpDir: URL!
    var store: EnvironmentStore!

    init() throws {
        tmpDir = FileManager.default.temporaryDirectory
            .appendingPathComponent("orbital-export-tests-\(UUID().uuidString)")
        try FileManager.default.createDirectory(at: tmpDir, withIntermediateDirectories: true)
        store = EnvironmentStore(homeURL: tmpDir)
    }

    @Test("exports CLAUDE_CONFIG_DIR when claude tool is configured")
    func exportClaudeDir() throws {
        let env = OrbitalEnvironment(name: "work", tools: [.claude])
        try store.save(env)
        try store.addTool(.claude, to: "work")

        let lines = try ExportCommand.exportLines(for: "work", store: store)
        let claudeDir = store.toolConfigDir(tool: .claude, environment: "work").path
        #expect(lines.contains("export CLAUDE_CONFIG_DIR=\(claudeDir)"))
    }

    @Test("exports custom env vars")
    func exportCustomVars() throws {
        let env = OrbitalEnvironment(name: "work", env: ["ANTHROPIC_API_KEY": "sk-test"])
        try store.save(env)

        let lines = try ExportCommand.exportLines(for: "work", store: store)
        #expect(lines.contains("export ANTHROPIC_API_KEY=sk-test"))
    }

    @Test("unexport lines for tool vars and custom vars")
    func unexportLines() throws {
        let env = OrbitalEnvironment(name: "work", tools: [.claude], env: ["ANTHROPIC_API_KEY": "sk-test"])
        try store.save(env)
        try store.addTool(.claude, to: "work")

        let lines = try UnexportCommand.unexportLines(for: "work", store: store)
        #expect(lines.contains("unset CLAUDE_CONFIG_DIR"))
        #expect(lines.contains("unset ANTHROPIC_API_KEY"))
    }
}
