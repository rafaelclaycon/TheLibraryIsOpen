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
        do {
            try flushTmpDirectory()
        } catch {
            fatalError()
        }
    }
    
    static func getAllArchivedEpisodesURLFor(podcastId: Int) -> URL {
        let documentsDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsDirURL.appendingPathComponent("\(InternalDirectoryNames.podcasts)/\(podcastId)")
    }
    
    static func createExportedArchivesDirectory() -> Bool {
        let documentsDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let newDirPath = documentsDirURL.appendingPathComponent(InternalDirectoryNames.exportedArchives)
        do {
            try FileManager.default.createDirectory(atPath: newDirPath.path, withIntermediateDirectories: true, attributes: nil)
            return true
        } catch {
            return false
        }
    }
    
    static func existsInsideDocumentsDirectory(directoryName: String) -> Bool {
        var documentsDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        documentsDirURL.appendPathComponent(directoryName)
        return Utils.directoryExistsAtPath(documentsDirURL.path)
    }
    
    static func prepareFilesInPodcastFolderForExport(paths: [String], podcastId: Int) throws -> URL {
        let documentsDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let podcastsDirURL = documentsDirURL.appendingPathComponent("\(InternalDirectoryNames.podcasts)/\(podcastId)")
        let tempDirURL = URL(fileURLWithPath: NSTemporaryDirectory())
        let podcastTempDirURL = tempDirURL.appendingPathComponent("\(podcastId)/", isDirectory: true)
        
        try FileManager.default.createDirectory(at: podcastTempDirURL, withIntermediateDirectories: false, attributes: nil)
        
        var fromPath = ""
        var toPath = ""
        
        for episodeLastPathComponent in paths {
            fromPath = podcastsDirURL.appendingPathComponent(episodeLastPathComponent).path
            toPath = podcastTempDirURL.appendingPathComponent(episodeLastPathComponent).path
            try FileManager.default.copyItem(atPath: fromPath, toPath: toPath)
        }
        
        return tempDirURL
    }
    
    static func flushTmpDirectory() throws {
        FileManager.default.clearTmpDirectory()
    }

}
