// swift-tools-version:5.4
import PackageDescription


let package = Package(
	name: "ls-diff",
	products: [
		.executable(name: "ls-diff", targets: ["ls-diff"])
	],
	dependencies: [
		.package(url: "https://github.com/apple/swift-argument-parser.git", .branch("async"))
	],
	targets: [
		.executableTarget(name: "ls-diff", dependencies: [
			.product(name: "ArgumentParser", package: "swift-argument-parser"),
		], swiftSettings: [
			.unsafeFlags([
				"-Xfrontend",
				"-enable-experimental-concurrency"
			])
		]),
		.testTarget(name: "lsdiffTests", dependencies: ["ls-diff"])
	]
)
