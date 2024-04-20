import PackagePlugin
import Foundation

@main
struct AutoRegistery: CommandPlugin {
    func performCommand(context: PackagePlugin.PluginContext, arguments: [String]) async throws {
        try generateRegistry(context: context)
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension AutoRegistery: XcodeCommandPlugin {
    func performCommand(context: XcodeProjectPlugin.XcodePluginContext, arguments: [String]) throws {
        try generateRegistry(context: context)
    }
}
#endif

private func generateRegistry(context: Context) throws {
    let sourcery = context.root.appending("bin").appending("sourcery").string
    let template = context.root.appending("Registry.stencil").string
    let sources = context.root.appending("..").string
    let output = context.root.appending("Sources").appending("Registry").appending("Registry.generated.swift").string

    let task = Process()
    task.launchPath = sourcery
    task.arguments = ["--sources", sources, "--templates", template, "--output", output, "--disableCache"]
    try task.run()
}

protocol Context {
    var root: Path { get }
}

extension XcodeProjectPlugin.XcodePluginContext: Context {
    var root: Path {
        xcodeProject.directory.appending("ServiceRegistry")
    }
}

extension PackagePlugin.PluginContext: Context {
    var root: Path {
        package.directory
    }
}
