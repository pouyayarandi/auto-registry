import PackagePlugin
import Foundation
import CryptoKit

@main
struct RegisteryChecker: BuildToolPlugin {
    func createBuildCommands(context: PackagePlugin.PluginContext, target: any PackagePlugin.Target) async throws -> [PackagePlugin.Command] {
        []
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension RegisteryChecker: XcodeBuildToolPlugin {
    func createBuildCommands(context: XcodeProjectPlugin.XcodePluginContext, target: XcodeProjectPlugin.XcodeTarget) throws -> [PackagePlugin.Command] {
        let grep = try context.tool(named: "grep").path.string

        let root = context.xcodeProject.directory.string
        let excluded = context.xcodeProject.directory.appending("AutoRegistery").string
        let serviceRegisteryFile = "\(context.xcodeProject.directory)/AutoRegistery/Sources/Registery/Registery.swift"

        try checkServices(grep, excluded, root, serviceRegisteryFile)

        return []
    }
}
#endif

private func checkServices(_ grep: String, _ excluded: String, _ root: String, _ serviceRegisteryFile: String) throws {
    let task = Process()
    let pipe = Pipe()

    task.standardOutput = pipe
    task.standardError = pipe
    task.launchPath = grep
    task.arguments = ["--exclude-dir=\(excluded)", "-rhno", root, "-e", "^@Service\\((.*)\\)"]
    try task.run()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)!

    let services = output.components(separatedBy: "\n")
        .compactMap({ $0.components(separatedBy: ":").last })
        .filter({ !$0.isEmpty })
        .map({ $0.replacingOccurrences(of: "@Service(\"", with: "") })
        .map({ $0.replacingOccurrences(of: "\")", with: "") })

    guard
        let data = FileManager.default.contents(atPath: serviceRegisteryFile),
        let content = String(data: data, encoding: .utf8) else {
        fatalError("Could not find reference for services")
    }

    let hash = "// hash_\(services.joined(separator: ",").sha256)"

    if !content.hasPrefix(hash) {
        fatalError("Registery file is outdated, please regenerate it using AutoRegistery command.")
    }
}

extension SHA256 {
    static func hash(_ string: String) -> String {
        let data = string.data(using: .utf8)!
        let hashedData = Self.hash(data: data)
        return hashedData
            .compactMap({ String(format: "%02x", $0) })
            .joined()
    }
}

extension String {
    var sha256: String {
        SHA256.hash(self)
    }
}
