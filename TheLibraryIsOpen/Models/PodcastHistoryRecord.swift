import Foundation

struct PodcastHistoryRecord: Hashable, Codable, Identifiable {

    var id: String
    var podcastId: Int
    var symbol: String?
    var title: String
    var description: String?
    var dateTime: Date
    
    init(id: String = UUID().uuidString,
         podcastId: Int = 0,
         symbol: String? = nil,
         title: String = "",
         description: String? = nil,
         dateTime: Date = Date()) {
        self.id = id
        self.podcastId = podcastId
        self.symbol = symbol
        self.title = title
        self.description = description
        self.dateTime = dateTime
    }

}

enum HistoryRecordSymbol: String {

    case podcastArchived = "sparkles"
    case exportedToFiles = "folder"

}
