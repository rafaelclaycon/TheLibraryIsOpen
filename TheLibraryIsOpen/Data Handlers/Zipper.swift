import Foundation
import ZIPFoundation

class Zipper {

    static func zip(episodes: [String], of podcastId: Int, _ podcastTitle: String) throws -> URL {
        var adaptedPaths = [String]()
        episodes.forEach { episodePath in
            adaptedPaths.append(episodePath.replacingOccurrences(of: "Podcasts/\(podcastId)/", with: ""))
        }
        
        // Delete ExportedArchives to avoid naming conflicts
        if InternalStorage.existsInsideDocumentsDirectory(directoryName: InternalDirectoryNames.exportedArchives) {
            guard InternalStorage.deleteDirectoryInDocumentsDirectory(withName: InternalDirectoryNames.exportedArchives) else {
                throw ZipperError.failedToDeleteExportedArchivesDirectory
            }
        }
        
        // Move selected episodes to a different export folder
        let sourceURL = try InternalStorage.prepareFilesInPodcastFolderForExport(paths: adaptedPaths, podcastId: podcastId)
        
        // Prepare exported .zip file name
        var name = ""
        if episodes.count == 1 {
            name = String(format: LocalizableStrings.ArchivedPodcastDetail.Export.exportedFileNameSingleEpisode, podcastTitle, Date().asDashSeparatedYMDString())
        } else {
            name = String(format: LocalizableStrings.ArchivedPodcastDetail.Export.exportedFileNameMultipleEpisodes, podcastTitle, episodes.count, Date().asDashSeparatedYMDString())
        }
        
        // Prepare exported .zip file path
        var destinationURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        destinationURL.appendPathComponent("\(InternalDirectoryNames.exportedArchives)/" + name + ".zip")
        
        // Creates ExportedArchives directory
        guard InternalStorage.createExportedArchivesDirectory() else {
            throw ZipperError.failedToCreateExportedArchivesDirectory
        }
        
        // Create .zip file
        let fileManager = FileManager()
        try fileManager.zipItem(at: sourceURL, to: destinationURL)
        return destinationURL
    }

}

enum ZipperError: Error {

    case failedToDeleteExportedArchivesDirectory
    case failedToCreateExportedArchivesDirectory

}
