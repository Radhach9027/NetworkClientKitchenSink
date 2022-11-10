import Foundation

extension FileManager {
    static func createFolder(folder: String) throws -> URL {
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryURL = documentDirectoryURL.appendingPathComponent(folder, isDirectory: true)

        if FileManager.default.fileExists(atPath: directoryURL.path) {
            return directoryURL
        } else {
            do {
                try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
                return directoryURL
            } catch {
                throw error
            }
        }
    }
}
