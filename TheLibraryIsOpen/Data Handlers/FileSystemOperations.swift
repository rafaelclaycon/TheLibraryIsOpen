import Foundation

class FileSystemOperations {

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
        
        var fromPath = String.empty
        var toPath = String.empty
        
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
    
    static func getActualSizeOfFile(atPath filePath: String) -> Int? {
        let documentsDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsDirURL.appendingPathComponent("\(InternalDirectoryNames.podcasts)/\(filePath)")
        
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return nil
        }
        
        var fileSize: Int
        do {
            let attr = try FileManager.default.attributesOfItem(atPath: fileURL.path)
            fileSize = attr[FileAttributeKey.size] as! Int
            return fileSize
        } catch {
            print("Error: \(error)")
            return nil
        }
    }

}
