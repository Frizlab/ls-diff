// swift-tools-version:5.4
import PackageDescription


let package = Package(
	name: "ls-diff",
	products: [
		.executable(name: "ls-diff", targets: ["ls-diff"])
	],
	dependencies: [
		.package(url: "https://github.com/apple/swift-argument-parser.git", from: "0.4.3")
	],
	targets: [
		.executableTarget(name: "ls-diff", dependencies: [
			.product(name: "ArgumentParser", package: "swift-argument-parser"),
		]),
		.testTarget(name: "lsdiffTests", dependencies: ["ls-diff"])
	]
)
