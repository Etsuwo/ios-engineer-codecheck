//
//  File.swift
//
//
//  Created by Etsushi Otani on 2022/05/12.
//

import PackagePlugin

@main
struct SwiftGenPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        let outputDir = context.pluginWorkDirectory
        let colorAssets = target.directory.appending("Resources/Colors.xcassets")
        let imageAssets = target.directory.appending("Resources/Images.xcassets")
        let assetsOutputFile = outputDir.appending("Color.generated.swift")
        let strings = target.directory.appending("Resources/Localizable.strings")
        let stringsOutputFile = outputDir.appending("Strings.generated.swift")
        return [
            .buildCommand(
                displayName: "SwiftGen",
                executable: try context.tool(named: "swiftgen").path,
                arguments: [
                    "run",
                    "xcassets",
                    colorAssets.string,
                    imageAssets.string,
                    "--param",
                    "publicAccess",
                    "--templateName",
                    "swift5",
                    "--output",
                    assetsOutputFile.string,
//                    "config",
//                    "run",
//                    "--config",
//                    target.directory.appending("Resources/swiftgen.yml").string,
                ],
                environment: [:],
                inputFiles: [colorAssets, imageAssets],
                outputFiles: [assetsOutputFile]
            ),
            .buildCommand(
                displayName: "SwiftGen",
                executable: try context.tool(named: "swiftgen").path,
                arguments: [
                    "run",
                    "strings",
                    strings.string,
                    "--param",
                    "publicAccess",
                    "--templateName",
                    "structured-swift5",
                    "--output",
                    stringsOutputFile.string,
                ],
                environment: [:],
                inputFiles: [strings],
                outputFiles: [stringsOutputFile]
            )
        ]
    }
}
