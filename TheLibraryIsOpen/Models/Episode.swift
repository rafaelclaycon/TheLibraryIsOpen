import Foundation

struct Episode: Hashable, Codable, Identifiable {

    var id: String
    var podcastId: Int
    var title: String
    var pubDate: Date?
    var duration: Double
    var remoteUrl: String
    var localFilepath: String?
    var filesize: Int
    var offlineStatus: Int
    
    init(id: String = UUID().uuidString,
         podcastId: Int = 0,
         title: String = "",
         pubDate: Date? = Date(),
         duration: Double = 0,
         remoteUrl: String = "",
         filesize: Int = 0,
         offlineStatus: EpisodeOfflineStatus = .downloadNotStarted) {
        self.id = id
        self.podcastId = podcastId
        self.title = title
        self.pubDate = pubDate
        self.duration = duration
        self.remoteUrl = remoteUrl
        self.localFilepath = nil
        self.filesize = filesize
        self.offlineStatus = offlineStatus.rawValue
    }

}

enum EpisodeOfflineStatus: Int, Codable {
    
    case downloadNotStarted = 0, downloading = 1, availableOffline = 2, downloadError = 3

}

enum SortOption {
    
    case fromNewToOld, fromOldToNew
    
}
