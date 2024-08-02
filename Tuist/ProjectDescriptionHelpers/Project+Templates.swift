import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

extension Project {
    static let mainAppTarger = "kidsnote-pre-project"
    static let additionalTargets = ["pre-kit", "pre-ui"]
    static let appBundleId = "com.op1000.kidsnote-pre-project"
    static let targetBundleIds = ["kit", "ui"]
    
    /// Helper function to create the Project for this ExampleApp
    public static func app(name: String, platform: Platform) -> Project {
        let codeSign = SettingsDictionary()
            .codeSignIdentityAppleDevelopment()
            .automaticCodeSigning(devTeam: "CLA95FJCV2")
        let settings: Settings = .settings(
            base: SettingsDictionary()
                .merging(codeSign),
            configurations: [
                .debug(name: .debug, xcconfig: .none),
            ],
            defaultSettings: .recommended
        )
        
        var targets = makeAppTargets(
            name: name,
            platform: platform)
        
        for index in 0..<additionalTargets.count {
            let name = additionalTargets[index]
            let bundleIdPostFix = targetBundleIds[index]
            let target =  makeFrameworkTargets(name: name, appBundleId: appBundleId, bundleIdPostFix: bundleIdPostFix)
            targets.append(contentsOf: target)
        }
        
        return Project(
            name: name,
            organizationName: "kidsnote-pre-project",
            settings: settings,
            targets: targets,
            resourceSynthesizers: [
                .strings(),
                .assets(),
                .fonts()
            ]
        )
    }

    // MARK: - Private
    
    /// Helper function to create a framework target and an associated unit test target
    private static func makeFrameworkTargets(name: String, appBundleId: String, bundleIdPostFix: String) -> [Target] {
        var dependencies: [ProjectDescription.TargetDependency] = []
        if name == "pre-ui" {
            dependencies.append(.target(name: "pre-kit"))
        }
            
        let sources = Target(
            name: name,
            platform: .iOS,
            product: .framework,
            bundleId: "\(appBundleId).\(bundleIdPostFix)",
            deploymentTarget: .iOS(targetVersion: "16.0", devices: [.iphone]),
            infoPlist: .default,
            sources: ["Targets/\(name)/Sources/**"],
            resources: [],
            dependencies: dependencies
        )
        return [sources]
    }

    /// Helper function to create the application target and the unit test target.
    private static func makeAppTargets(name: String, platform: Platform) -> [Target] {
        let platform: Platform = platform
        let mainTarget = Target(
            name: name,
            platform: platform,
            product: .app,
            bundleId: appBundleId,
            deploymentTarget: .iOS(targetVersion: "16.0", devices: [.iphone]),
            infoPlist: .file(path: .relativeToRoot("Targets/\(name)/Supporting Files/Info.plist")),
            sources: ["Targets/\(name)/Sources/**"],
            resources: ["Targets/\(name)/Resources/**"],
            dependencies: [
                .target(name: "pre-kit"),
                .target(name: "pre-ui"),
            ]
        )
        return [mainTarget]
    }
}
