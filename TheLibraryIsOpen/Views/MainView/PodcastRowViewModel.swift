import Foundation
import Combine

class PodcastRowViewModel: ObservableObject {
    
    @Published var artworkUrl: String
    @Published var podcastTitle: String
    @Published var episodeCountText: String
    @Published var totalSizeText: String
    @Published var wasExportedLine: String
    
    init(podcast: Podcast? = nil) {
        artworkUrl = podcast?.artworkUrl ?? ""
        podcastTitle = podcast?.title ?? ""
        
        let episodeCount: Int = podcast?.episodes?.count ?? 0
        
        if episodeCount == 0 {
            episodeCountText = LocalizableStrings.MainView.PodcastRow.episodeCountNoEpisodes
        } else if episodeCount == 1 {
            episodeCountText = LocalizableStrings.MainView.PodcastRow.episodeCountSingleEpisode
        } else {
            episodeCountText = String(format: LocalizableStrings.MainView.PodcastRow.episodeCountMultipleEpisodes, episodeCount)
        }
        
        if episodeCount == 0 {
            totalSizeText = LocalizableStrings.MainView.PodcastRow.noSizeInformation
        } else {
            totalSizeText = Utils.getFormattedFileSize(of: Int64(podcast?.totalSize ?? 0))
        }
        
        wasExportedLine = LocalizableStrings.MainView.PodcastRow.notExportedYet
    }
    
}
