// swift-tools-version:5.3
import PackageDescription


let package = Package(
	name: "ls-diff",
	dependencies: [
		.package(url: "https://github.com/apple/swift-argument-parser.git", from: "0.4.3")
	],
	targets: [
		.target(name: "ls-diff", dependencies: [
			.product(name: "ArgumentParser", package: "swift-argument-parser")
		]),
		.testTarget(name: "lsdiffTests", dependencies: ["ls-diff"])
	]
)
