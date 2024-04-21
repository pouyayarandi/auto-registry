import PackagePlugin
import Foundation
import CryptoKit

struct BuildError: Error, CustomStringConvertible {
    let message: String
    var description: String { message }
}

struct Result: Codable {
    struct Item: Codable {
        let outputPath: String
        let value: String
    }

    let outputs: [Item]
}

@main
struct RegisteryChecker: BuildToolPlugin {
    func createBuildCommands(context: PackagePlugin.PluginContext, target: any PackagePlugin.Target) async throws -> [PackagePlugin.Command] {
        try checkRegistry(context: context)
        return []
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension RegisteryChecker: XcodeBuildToolPlugin {
    func createBuildCommands(context: XcodeProjectPlugin.XcodePluginContext, target: XcodeProjectPlugin.XcodeTarget) throws -> [PackagePlugin.Command] {
        try checkRegistry(context: context)
        return []
    }
}
#endif

private func checkRegistry(context: Context) throws {
    let sources = context.root.string
    let sourcery = context.plugin.appending("bin").appending("sourcery").string
    let template = context.plugin.appending("Registry.stencil").string
    let output = context.plugin.appending("Sources").appending("Registry").appending("Registry.generated.swift").string

    let task = Process()
    let pipe = Pipe()

    task.standardOutput = pipe
    task.standardError = pipe
    task.launchPath = sourcery
    task.arguments = ["--sources", sources, "--templates", template, "--output", output, "--disableCache", "--dry"]
    try task.run()

    guard let data = try pipe.fileHandleForReading.readToEnd(), let value = try JSONDecoder().decode(Result.self, from: data).outputs.first(where: { $0.outputPath.hasSuffix("Registry.generated.swift") }) else {
        throw BuildError(message: "Could not generate registry code to compare with the current registry.")
    }
    guard let fileContent = FileManager.default.contents(atPath: output), let fileContentString = String(data: fileContent, encoding: .utf8) else {
        throw BuildError(message: "Could not read Registry.generated.swift file content.")
    }
    if value.value != fileContentString {
        throw BuildError(message: "Registry file is outdated. Please regenerate it using command plugin and build project again.")
    }
}

protocol Context {
    var root: Path { get }
    var plugin: Path { get }
}

extension XcodeProjectPlugin.XcodePluginContext: Context {
    var root: Path {
        xcodeProject.directory
    }

    var plugin: Path {
        root.appending("ServiceRegistry")
    }
}

extension PackagePlugin.PluginContext: Context {
    var root: Path {
        package.directory.appending("..")
    }

    var plugin: Path {
        package.directory
    }
}
