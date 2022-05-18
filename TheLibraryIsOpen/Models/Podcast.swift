import Foundation

struct Podcast: Hashable, Codable, Identifiable {

    var id: Int
    var title: String
    var author: String
    var episodes: [Episode]?
    var feedUrl: String
    var artworkUrl: String
    var lastCheckDate: Date?
    var totalSize: Int?
    var exportedIn: Date?
    var lastExportedEpisodeCount: Int?
    var isSecured: Bool
    
    init(id: Int,
         title: String = .empty,
         author: String = .empty,
         episodes: [Episode]? = nil,
         feedUrl: String = .empty,
         artworkUrl: String = .empty,
         lastCheckDate: Date? = nil,
         totalSize: Int? = nil,
         exportedIn: Date? = nil,
         lastExportedEpisodeCount: Int? = nil,
         isSecured: Bool = false) {
        self.id = id
        self.title = title
        self.author = author
        self.episodes = episodes
        self.feedUrl = feedUrl
        self.artworkUrl = artworkUrl
        self.lastCheckDate = lastCheckDate
        self.totalSize = totalSize
        self.exportedIn = exportedIn
        self.lastExportedEpisodeCount = lastExportedEpisodeCount
        self.isSecured = isSecured
    }

}

enum ArchivedPodcastSubdetailViewToShow: Int, Codable {

    case exportSuccessfulView, episodeDetailView

}
