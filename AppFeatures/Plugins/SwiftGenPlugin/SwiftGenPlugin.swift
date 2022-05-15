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
//        let targetAssets = target.directory.appending("Files/Colors.xcassets")
//        let outputFile = outputDir.appending("Color.generated.swift")
        return [
            .prebuildCommand(
                displayName: "SwiftGen",
                executable: try context.tool(named: "swiftgen").path,
                arguments: [
                    //                    "run",
//                    "xcassets",
//                    targetAssets.string,
//                    "--param",
//                    "publicAccess",
//                    "--templateName",
//                    "swift5",
//                    "--output",
//                    outputFile.string,
                    "config",
                    "run",
                    "--config",
                    target.directory.appending("Files/swiftgen.yml").string,
                ],
                environment: ["OUT_DIR": outputDir.string],
                outputFilesDirectory: outputDir
            )
        ]
    }
}
