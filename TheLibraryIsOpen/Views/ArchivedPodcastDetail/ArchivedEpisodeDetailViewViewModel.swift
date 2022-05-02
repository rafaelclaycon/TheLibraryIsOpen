import Combine
import UIKit

class ArchivedEpisodeDetailViewViewModel: ObservableObject {

    @Published var episodeIsDownloaded: Bool
    @Published var artwork: Data?
    @Published var title: String
    @Published var fileSize: String
    @Published var publicationDate: String
    @Published var duration: String
    @Published var description: String
    
    init(episode: Episode?) {
        guard let episode = episode else {
            episodeIsDownloaded = false
            artwork = nil
            title = "Error"
            fileSize = .empty
            publicationDate = .empty
            duration = .empty
            description = .empty
            return
        }
        episodeIsDownloaded = episode.offlineStatus == EpisodeOfflineStatus.availableOffline.rawValue
        artwork = MP3MetadataExtractor.getEpisodeArtwork(from: episode.localFilepath ?? .empty)
        title = episode.title
        fileSize = episode.filesize.toFormattedFileSize()
        publicationDate = episode.pubDate?.asLongString() ?? .empty
        duration = episode.duration.toDisplayString()
        description = MP3MetadataExtractor.getEpisodeDescription(from: episode.localFilepath ?? .empty) ?? .empty
    }
    
}
