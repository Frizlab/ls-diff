import Foundation

import ArgumentParser



@main
struct LsDiff : ParsableCommand {
	
	@Flag
	var computeSizeDiffToo = false
	
	@Flag(inversion: .prefixedNo)
	var skipDiff1 = true
	
	@Flag(inversion: .prefixedNo)
	var skipDiff2 = false
	
	@Argument
	var folder1: String
	
	@Argument
	var folder2: String
	
	func run() async throws {
		let paths1 = try await ListFiles.listFiles(in: URL(fileURLWithPath: folder1), withSizes: computeSizeDiffToo)
		let paths2 = try await ListFiles.listFiles(in: URL(fileURLWithPath: folder2), withSizes: computeSizeDiffToo)
		
		var hasDiff = false
		if !skipDiff1 {let diff = paths1.subtracting(paths2); hasDiff = hasDiff || !diff.isEmpty; printDiff(diff, folderName: folder1)}
		if !skipDiff2 {let diff = paths2.subtracting(paths1); hasDiff = hasDiff || !diff.isEmpty; printDiff(diff, folderName: folder2)}
		
		if hasDiff {throw ExitCode(1)}
		else       {throw ExitCode(0)}
	}
	
	private func printDiff(_ diff: Set<ListFiles.File>, folderName: String) {
		if diff.count > 0 {
			print("Only in \(folderName)\(computeSizeDiffToo ? " (or filesize differs)" : ""):")
			for f in diff.sorted(by: { $0.relativePath < $1.relativePath }) {
				print("   - \(f.relativePath)")
			}
		}
	}
	
}
