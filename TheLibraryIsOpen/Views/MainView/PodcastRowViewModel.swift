import Foundation
import Combine

class PodcastRowViewModel: ObservableObject {
    
    @Published var artworkUrl: String
    @Published var podcastTitle: String
    @Published var subtitleLine: String
    @Published var wasExportedLine: String
    
    init(podcast: Podcast? = nil) {
        artworkUrl = podcast?.artworkUrl ?? ""
        podcastTitle = podcast?.title ?? ""
        
        let episodeCount: Int = podcast?.episodes?.count ?? 0
        
        if episodeCount == 0 {
            subtitleLine = LocalizableStrings.MainView.PodcastRow.episodeCountNoEpisodes
        } else if episodeCount == 1 {
            subtitleLine = LocalizableStrings.MainView.PodcastRow.episodeCountSingleEpisode
        } else {
            subtitleLine = String(format: LocalizableStrings.MainView.PodcastRow.episodeCountMultipleEpisodes, episodeCount)
        }
        
        wasExportedLine = LocalizableStrings.MainView.PodcastRow.notExportedYet
    }
    
}
