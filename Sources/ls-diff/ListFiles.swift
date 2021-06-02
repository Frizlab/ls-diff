import Foundation



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
	static func listFiles(in folder: URL, withSizes: Bool) async throws -> Set<File> {
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
			let path = url.absoluteURL.path
			guard path.hasPrefix(rootFolderPath) else {
				throw Err.enumeratorReturnedAnURLOutsideOfRootFolder
			}
			let size = withSizes ? try url.resourceValues(forKeys: [.fileSizeKey]).fileSize : nil
			ret.insert(File(relativePath: String(path.dropFirst(rootFolderPath.count)), size: size))
		}
		return ret
	}
	
}
