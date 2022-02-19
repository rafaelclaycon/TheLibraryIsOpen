import Foundation

struct PodcastHistoryRecord: Hashable, Codable, Identifiable {

    var id: String
    var podcastId: Int
    var type: Int
    var value1: String
    var value2: String?
    var dateTime: Date
    
    init(id: String = UUID().uuidString,
         podcastId: Int = 0,
         type: Int,
         value1: String,
         value2: String? = nil,
         dateTime: Date = Date()) {
        self.id = id
        self.podcastId = podcastId
        self.type = type
        self.value1 = value1
        self.value2 = value2
        self.dateTime = dateTime
    }

}

enum HistoryRecordType: Int, Codable {

    case podcastArchived, archiveExported, checkedForNewEpisodes, newEpisodesDownloaded

}
