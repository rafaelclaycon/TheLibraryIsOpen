import Foundation
import Combine

class ArchivedEpisodeRowViewModel: ObservableObject {

    var podcastID: Int
    var episodeID: String
    var offlineStatus: EpisodeOfflineStatus
    var showEpisodeArtwork: Bool
    var episodeFilepath: String?

    @Published var title: String
    @Published var subtitle: String

    init(episode: Episode, showEpisodeArtwork: Bool) {
        podcastID = episode.podcastId
        episodeID = episode.id
        offlineStatus = EpisodeOfflineStatus(rawValue: episode.offlineStatus) ?? .notMarkedForDownload
        self.showEpisodeArtwork = showEpisodeArtwork
        self.episodeFilepath = episode.localFilepath

        title = episode.title
        subtitle = (episode.pubDate?.asShortString() ?? "")  + " - " + episode.duration.toDisplayString() + " - " + episode.filesize.toFormattedFileSize()
    }

}
