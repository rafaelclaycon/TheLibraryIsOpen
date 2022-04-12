import Foundation
import Combine

class PodcastRowViewModel: ObservableObject {

    @Published var artworkUrl: String
    @Published var podcastTitle: String
    @Published var episodeCountText: String
    @Published var totalSizeText: String
    @Published var wasExported: Bool
    @Published var wasExportedLine: String
    
    init(podcast: Podcast? = nil) {
        artworkUrl = podcast?.artworkUrl ?? .empty
        podcastTitle = podcast?.title ?? .empty
        
        let downloadedEpisodes = podcast?.episodes?.filter {
            $0.offlineStatus == EpisodeOfflineStatus.availableOffline.rawValue
        }
        
        let episodeCount: Int = downloadedEpisodes?.count ?? 0
        
        episodeCountText = String(format: LocalizableStrings.MainView.PodcastRow.episodeCountMultipleEpisodes, episodeCount, podcast!.episodes!.count)
        
        if episodeCount == 0 {
            totalSizeText = LocalizableStrings.MainView.PodcastRow.noSizeInformation
        } else {
            totalSizeText = Utils.getFormattedFileSize(of: podcast?.totalSize ?? 0)
        }
        
        if let exportDate = podcast?.exportedIn {
            wasExported = true
            wasExportedLine = String(format: LocalizableStrings.MainView.PodcastRow.exportedAt, exportDate.asRelativeDate())
        } else {
            wasExported = false
            wasExportedLine = LocalizableStrings.MainView.PodcastRow.notExportedYet
        }
    }

}
