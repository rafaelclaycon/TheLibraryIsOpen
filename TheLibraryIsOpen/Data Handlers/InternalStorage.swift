import Foundation

class InternalStorage {
    
    static func getDeviceFreeStorage() -> Int64 {
        if let simulatedFreeSpace = ProcessInfo.processInfo.environment["SimulatedFreeDiskSpaceInBytes"] {
            return Int64(simulatedFreeSpace) ?? 0
        }
        
        guard let freeSpace = try? URL(fileURLWithPath: NSHomeDirectory() as String).resourceValues(forKeys: [URLResourceKey.volumeAvailableCapacityForImportantUsageKey]).volumeAvailableCapacityForImportantUsage else {
            return 0
        }
        return freeSpace
    }

    static func deleteDirectoryInDocumentsDirectory(withName directoryName: String) -> Bool {
        var exportedArchivesURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        exportedArchivesURL.appendPathComponent(directoryName)
        do {
            try FileManager.default.removeItem(at: exportedArchivesURL)
            return true
        } catch {
            return false
        }
    }
    
    static func cleanUp() {
        let _ = deleteDirectoryInDocumentsDirectory(withName: InternalDirectoryNames.podcasts)
        let _ = deleteDirectoryInDocumentsDirectory(withName: InternalDirectoryNames.exportedArchives)
    }
    
    static func getAllArchivedEpisodesURLFor(podcastId: Int) -> URL {
        let documentsDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsDirURL.appendingPathComponent("\(InternalDirectoryNames.podcasts)/\(podcastId)")
    }
    
    static func createExportedArchivesDirectory() -> Bool {
        let documentsDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let newDirPath = documentsDirURL.appendingPathComponent(InternalDirectoryNames.exportedArchives)
        do {
            try FileManager.default.createDirectory(atPath: newDirPath.absoluteString, withIntermediateDirectories: true, attributes: nil)
            return true
        } catch {
            return false
        }
    }

}
