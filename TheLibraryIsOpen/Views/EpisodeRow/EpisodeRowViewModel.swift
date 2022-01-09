import Combine
import Foundation

class EpisodeRowViewModel: ObservableObject {

    var podcastID: Int
    var episodeID: String

    @Published var title: String
    @Published var subtitle: String

    init(episode: Episode, selected: Bool = false) {
        podcastID = episode.podcastId
        episodeID = episode.id

        title = episode.title
        subtitle = (episode.pubDate?.asShortString() ?? "")  + " - " + episode.duration.toDisplayString() + " - " + episode.filesize.toFormattedFileSize()
    }

}
