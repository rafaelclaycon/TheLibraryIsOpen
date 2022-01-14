import Combine
import Foundation

class PodcastPreviewViewModel: ObservableObject {
    
    var podcast: Podcast

    @Published var title: String
    @Published var details: String
    @Published var artworkURL: String
    @Published var displayEpisodeList: Bool = false
    
    // MARK: - Episode list variables
    @Published var episodes = [Episode]()
    @Published var selectionKeeper = Set<String>()
    @Published var allEpisodesSelected: Bool = true
    @Published var episodeListSorting: SortOption = .fromNewToOld
    
    // MARK: - Year group list variables
    @Published var groups = [EpisodeGroup]()
    @Published var allGroupsSelected: Bool = false
    
    // MARK: - Download button variables
    @Published var downloadAllButtonTitle = ""
    @Published var isAnyEpisodeSelected: Bool = false
    
    // MARK: - Alert variables
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    @Published var displayAlert: Bool = false

    // MARK: - Initialization
    init(podcast: Podcast) {
        self.podcast = podcast
        
        artworkURL = podcast.artworkUrl
        
        title = podcast.title
        details = podcast.episodes?.count ?? 0 > 0 ? Utils.getSubtituloPodcast(episodes: podcast.episodes!) : ""
        episodes = podcast.episodes ?? [Episode]()
        
        selectAllEpisodes()
        updateDownloadButton(selectedIDs: Array(selectionKeeper))
        
        if (podcast.episodes?.count ?? 0) > 0 {
            groups = Utils.getEpisodesGroupedByYear(from: podcast.episodes!)
        }
        
        displayEpisodeList = podcast.episodes?.count ?? 0 > 0
    }
    
    // MARK: - Select all methods
    func toggleSelectAll() {
        if allEpisodesSelected {
            unselectAllEpisodes()
        } else {
            selectAllEpisodes()
        }
    }
    
    func selectAllEpisodes() {
        selectionKeeper = Set(episodes.map{ $0.id })
        allEpisodesSelected = true
    }
    
    func unselectAllEpisodes() {
        selectionKeeper = Set()
        allEpisodesSelected = false
    }
    
    // MARK: - Sort episode list methods
    func toggleEpisodeListSorting() {
        if episodeListSorting == .fromNewToOld {
            sortEpisodesByPubDateDescending()
        } else {
            sortEpisodesByPubDateAscending()
        }
    }
    
    func sortEpisodesByPubDateAscending() {
        episodes.sort { $0.pubDate! < $1.pubDate! }
        episodeListSorting = .fromOldToNew
    }
    
    func sortEpisodesByPubDateDescending() {
        episodes.sort { $0.pubDate! > $1.pubDate! }
        episodeListSorting = .fromNewToOld
    }
    
    // MARK: - Download button methods
    func updateDownloadButton(selectedIDs: [String]) {
        let selectedEpisodes = episodes.filter {
            selectedIDs.contains($0.id)
        }
        if selectedEpisodes.count == 0 {
            downloadAllButtonTitle = LocalizableStrings.PodcastPreview.downloadButtonJustAddTitle
            isAnyEpisodeSelected = false
        } else if selectedEpisodes.count == 1 {
            downloadAllButtonTitle = LocalizableStrings.PodcastPreview.downloadEpisodesButtonTitle + " 1 " + LocalizableStrings.episode + Utils.getSizeOf(episodes: selectedEpisodes)
            isAnyEpisodeSelected = true
        } else {
            downloadAllButtonTitle = LocalizableStrings.PodcastPreview.downloadEpisodesButtonTitle + " \(selectedEpisodes.count) " + LocalizableStrings.episodes + Utils.getSizeOf(episodes: selectedEpisodes)
            isAnyEpisodeSelected = true
        }
    }
    
    func download(episodeIDs: Set<String>) -> Bool {
        let episodesToDownload = episodes.filter {
            episodeIDs.contains($0.id)
        }
        
        guard episodesToDownload.count > 0 else {
            showNoEpisodesSelectedAlert()
            return false
        }
        
        podcast.episodes = nil
        
        do {
            try dataManager.persist(podcast: podcast, withEpisodes: episodesToDownload)
        } catch DataManagerError.podcastAlreadyExists {
            showPodcastAlreadyExistsAlert(podcastName: podcast.title)
        } catch {
            showLocalStorageError(error.localizedDescription)
        }
        
        return true
    }
    
    // MARK: - Error message methods
    
    private func showPodcastAlreadyExistsAlert(podcastName: String) {
        alertTitle = "This Podcast was Already Archived"
        alertMessage = "It's not possible to add '\(podcastName)' because it already exists in the archive. If you would like to add more episodes, please go to the podcast's archive page."
        displayAlert = true
    }

    private func showPodcastIDNotFoundAlert() {
        alertTitle = "No Podcast Matching This ID Was Found"
        alertMessage = "Please try a different ID."
        displayAlert = true
    }

    private func showPodcastHadNoEpisodesAlert() {
        alertTitle = "This Podcast Has No Episodes"
        alertMessage = "No episodes were found for this podcast."
        displayAlert = true
    }
    
    private func showNoEpisodesSelectedAlert() {
        alertTitle = "No Episode Selected"
        alertMessage = "Select at least one episode to download."
        displayAlert = true
    }
    
    private func showLocalStorageError(_ errorBody: String) {
        alertTitle = "LocalStorage error"
        alertMessage = errorBody
        displayAlert = true
    }
    
    private func showGenericError(_ errorText: String) {
        alertTitle = errorText
        displayAlert = true
    }

}
