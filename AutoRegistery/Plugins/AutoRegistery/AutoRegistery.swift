import PackagePlugin
import Foundation

@main
struct AutoRegistery: CommandPlugin {

    fileprivate func registerServices(_ grep: String, _ excluded: String, _ root: String, _ serviceRegisteryFile: String) throws {
        let task = Process()
        let pipe = Pipe()

        task.standardOutput = pipe
        task.standardError = pipe
        task.launchPath = grep
        task.arguments = ["--exclude-dir=\(excluded)", "-rhno", root, "-e", "^@ServiceAPI\\((.*)\\)"]
        try task.run()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!

        let services = output.components(separatedBy: "\n")
            .compactMap({ $0.components(separatedBy: ":").last })
            .filter({ !$0.isEmpty })
            .map({ $0.replacingOccurrences(of: "@ServiceAPI(\"", with: "") })
            .map({ $0.replacingOccurrences(of: "\")", with: "") })

        var file = """
        // AUTO-GENERATED, Please don't change this file manually

        import Factory
        \(services.map({ "import \($0)_Wiring" }).joined(separator: "\n"))

        extension Container {
          public func registerDependencies() {

        """
        file += services.map({ "    \($0).register(factory: \($0)_Wiring.build)" }).joined(separator: "\n")
        file += """

          }
        }

        """

        try file.write(toFile: serviceRegisteryFile, atomically: true, encoding: .utf8)
    }

    func performCommand(context: PackagePlugin.PluginContext, arguments: [String]) async throws {
        let grep = try context.tool(named: "grep").path.string

        let root = context.package.directory.appending("..").string
        let excluded = context.package.directory.string
        let serviceRegisteryFile = "\(context.package.directory)/Sources/Registery/Registery.swift"

        try registerServices(grep, excluded, root, serviceRegisteryFile)
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension AutoRegistery: XcodeCommandPlugin {
    func performCommand(context: XcodeProjectPlugin.XcodePluginContext, arguments: [String]) throws {
        let grep = try context.tool(named: "grep").path.string

        let root = context.xcodeProject.directory.string
        let excluded = context.xcodeProject.directory.appending("AutoRegistery").string
        let serviceRegisteryFile = "\(context.xcodeProject.directory)/AutoRegistery/Sources/Registery/Registery.swift"

        try registerServices(grep, excluded, root, serviceRegisteryFile)
    }
}
#endif
