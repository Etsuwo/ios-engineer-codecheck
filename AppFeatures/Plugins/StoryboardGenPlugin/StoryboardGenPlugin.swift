//
//  File.swift
//
//
//  Created by Etsushi Otani on 2022/05/16.
//

import PackagePlugin

@main
struct StoryboardGenPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        let outputDir = context.pluginWorkDirectory
        let storyboards = target.directory.appending("Resources/Base.lproj")
        let output = outputDir.appending("Storyboard.generated.swift")

        return [
            .buildCommand(
                displayName: "SwiftGen",
                executable: try context.tool(named: "swiftgen").path,
                arguments: [
                    "run",
                    "ib",
                    storyboards.string,
                    "--param",
                    "publicAccess",
                    "--templateName",
                    "scenes-swift5",
                    "--output",
                    output.string,
                ],
                environment: [:],
                outputFiles: [output]
            )
        ]
    }
}
