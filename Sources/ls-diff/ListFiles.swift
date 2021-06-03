import Foundation



class ListFilesOperation : Operation {
	
	struct OperationNotFinished : Error {}
	
	let url: URL
	let withSizes: Bool
	let exclude: [NSRegularExpression]
	
	var result = Result<Set<ListFiles.File>, Error>.failure(OperationNotFinished())
	
	init(url: URL, withSizes: Bool, exclude: [NSRegularExpression]) {
		self.url = url
		self.withSizes = withSizes
		self.exclude = exclude
	}
	
	override func main() {
		result = Result{ try ListFiles.listFiles(in: url, withSizes: withSizes, exclude: exclude) }
	}
	
}


enum ListFiles {
	
	enum Err : Error {
		
		case invalidArgument
		case cannotCreateEnumerator
		case enumeratorReturnedANonURLObject
		case enumeratorReturnedAnURLOutsideOfRootFolder
		
	}
	
	struct File : Hashable {
		
		var relativePath: String
		var size: Int?
		
	}
	
	/** Returns a list of paths relative to the given URL folder */
	static func listFiles(in folder: URL, withSizes: Bool, exclude: [NSRegularExpression]) throws -> Set<File> {
		guard folder.isFileURL else {
			throw Err.invalidArgument
		}
		
		let rootFolderPath: String
		do {
			let p = folder.absoluteURL.path
			rootFolderPath = p + (p.hasSuffix("/") ? "" : "/")
		}
		
		let fm = FileManager.default
		guard let enumerator = fm.enumerator(at: folder, includingPropertiesForKeys: withSizes ? [.fileSizeKey] : []) else {
			throw Err.cannotCreateEnumerator
		}
		
		var ret = Set<File>()
		for nextObject in enumerator {
			guard let url = nextObject as? URL else {
				throw Err.enumeratorReturnedANonURLObject
			}
			let fullPath = url.absoluteURL.path
			guard fullPath.hasPrefix(rootFolderPath) else {
				throw Err.enumeratorReturnedAnURLOutsideOfRootFolder
			}
			let path = String(fullPath.dropFirst(rootFolderPath.count))
			guard !exclude.contains(where: { $0.rangeOfFirstMatch(in: path, range: NSRange(path.startIndex..<path.endIndex, in: path)).location != NSNotFound }) else {
				continue
			}
			let size = withSizes ? try url.resourceValues(forKeys: [.fileSizeKey]).fileSize : nil
			ret.insert(File(relativePath: path, size: size))
		}
		return ret
	}
	
}
