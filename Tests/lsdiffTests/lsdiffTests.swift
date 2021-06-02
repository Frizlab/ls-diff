import XCTest
import class Foundation.Bundle



final class lsdiffTests: XCTestCase {
	
	#if !targetEnvironment(macCatalyst)
	/* Mac Catalyst won't have `Process`, but it is supported for executables. */
	@available(macOS 10.13, *)
	func testExample() throws {
		let binaryURL = productsDirectory.appendingPathComponent("ls-diff")
		
		let process = Process()
		process.executableURL = binaryURL
		
		let pipe = Pipe()
		process.standardOutput = pipe
		
		try process.run()
		process.waitUntilExit()
		
		let data = pipe.fileHandleForReading.readDataToEndOfFile()
		let output = String(data: data, encoding: .utf8)
		
		XCTAssertEqual(output, "Hello, world!\n")
	}
	#endif
	
	/** Returns path to the built products directory. */
	var productsDirectory: URL {
		#if os(macOS)
		for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
			return bundle.bundleURL.deletingLastPathComponent()
		}
		fatalError("couldn't find the products directory")
		#else
		return Bundle.main.bundleURL
		#endif
	}
}
