import Foundation
import Combine

class ArchivedEpisodeRowViewModel: ObservableObject {

    var podcastID: Int
    var episodeID: String
    var offlineStatus: EpisodeOfflineStatus

    @Published var title: String
    @Published var subtitle: String

    init(episode: Episode, selected: Bool = false) {
        podcastID = episode.podcastId
        episodeID = episode.id
        offlineStatus = EpisodeOfflineStatus(rawValue: episode.offlineStatus) ?? .notMarkedForDownload

        title = episode.title
        subtitle = (episode.pubDate?.asShortString() ?? "")  + " - " + episode.duration.toDisplayString() + " - " + episode.filesize.toFormattedFileSize()
    }

}
