import Combine
import Foundation

class PodcastPreviewViewModel: ObservableObject {
    
    var podcast: Podcast
    var podcastPreviewDataManager: DataManager

    @Published var title: String
    @Published var details: String
    @Published var artworkURL: String
    @Published var displayEpisodeList: Bool = false
    
    // MARK: - Episode list variables
    @Published var episodes = [Episode]()
    @Published var episodeList_selectionKeeper = Set<String>()
    @Published var episodeList_allEpisodesSelected: Bool = true
    @Published var episodeListSorting: SortOption = .fromNewToOld
    
    // MARK: - Year group list variables
    @Published var yearGroups = [EpisodeGroup]()
    @Published var yearGroupList_selectionKeeper = Set<String>()
    
    // MARK: - Download button variables
    @Published var downloadAllButtonTitle = ""
    @Published var remainingStorageLabel = ""
    
    // MARK: - Alert variables
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    @Published var displayAlert: Bool = false
    @Published var alertType: AlertType = .singleOption

    // MARK: - Initialization
    init(podcast: Podcast, podcastPreviewDataManager: DataManager = dataManager) {
        self.podcast = podcast
        
        artworkURL = podcast.artworkUrl
        
        title = podcast.title
        details = podcast.episodes?.count ?? 0 > 0 ? Utils.getPodcastSubtitle(episodes: podcast.episodes!) : ""
        episodes = podcast.episodes ?? [Episode]()
        
        self.podcastPreviewDataManager = podcastPreviewDataManager
        
        selectAllEpisodes()
        updateDownloadButton(selectedIDs: Array(episodeList_selectionKeeper))
        
        if (podcast.episodes?.count ?? 0) > 0 {
            yearGroups = Utils.getEpisodesGroupedByYear(from: podcast.episodes!)
        }
        
        displayEpisodeList = podcast.episodes?.count ?? 0 > 0
    }
    
    // MARK: - Select all methods
    func toggleSelectAll() {
        if episodeList_allEpisodesSelected {
            unselectAllEpisodes()
        } else {
            selectAllEpisodes()
        }
    }
    
    func selectAllEpisodes() {
        for episode in episodes {
            episodeList_selectionKeeper.insert(episode.id)
        }
        episodeList_allEpisodesSelected = true
    }
    
    func unselectAllEpisodes() {
        episodeList_selectionKeeper = Set()
        episodeList_allEpisodesSelected = false
    }
    
    // MARK: - Sort episode list methods
    func toggleEpisodeListSorting() {
        if episodeListSorting == .fromNewToOld {
            episodeListSorting = .fromOldToNew
        } else {
            episodeListSorting = .fromNewToOld
        }
    }
    
    func sortEpisodesByPubDateAscending() {
        episodes.sort { $0.pubDate! < $1.pubDate! }
    }
    
    func sortEpisodesByPubDateDescending() {
        episodes.sort { $0.pubDate! > $1.pubDate! }
    }
    
    // MARK: - Download button methods
    func updateDownloadButton(selectedIDs: [String]) {
        let selectedEpisodes = episodes.filter {
            selectedIDs.contains($0.id)
        }
        if selectedEpisodes.count == 0 {
            downloadAllButtonTitle = LocalizableStrings.PodcastPreview.downloadButtonJustAddTitle
        } else if selectedEpisodes.count == 1 {
            downloadAllButtonTitle = LocalizableStrings.PodcastPreview.downloadEpisodesButtonTitle + " 1 " + LocalizableStrings.episode + Utils.getSizeOf(episodes: selectedEpisodes)
        } else {
            downloadAllButtonTitle = LocalizableStrings.PodcastPreview.downloadEpisodesButtonTitle + " \(selectedEpisodes.count) " + LocalizableStrings.episodes + Utils.getSizeOf(episodes: selectedEpisodes)
        }
    }
    
    func checkIfMeetsAllRequirementsToContinue() {
        guard episodeList_selectionKeeper.isEmpty == false else {
            return showNoEpisodesSelectedAlert()
        }
        
        let episodesToDownload: [Episode] = episodes.filter {
            episodeList_selectionKeeper.contains($0.id)
        }
        
        let remainingSpace = InternalStorage.getDeviceFreeStorage() - Utils.getSizeInBytesOf(episodesToDownload)
        
        guard remainingSpace > 2000000000 else {
            return showLowStorageWarning()
        }
        
        showPodcastAddingConfirmation(numberOfEpisodes: episodeList_selectionKeeper.count,
                                      podcastName: podcast.title)
    }
    
    func persistPodcastLocally() -> Bool {
        guard var episodes = podcast.episodes else {
            return false
        }
        
        for i in 0...(episodes.count - 1) {
            if episodeList_selectionKeeper.contains(episodes[i].id) {
                episodes[i].offlineStatus = EpisodeOfflineStatus.downloadNotStarted.rawValue
            } else {
                episodes[i].offlineStatus = EpisodeOfflineStatus.notMarkedForDownload.rawValue
            }
        }
        
        do {
            try podcastPreviewDataManager.persist(podcast: podcast, withEpisodes: episodes)
        } catch DataManagerError.podcastAlreadyExists {
            showPodcastAlreadyExistsAlert(podcastName: podcast.title)
            return false
        } catch {
            showLocalDatabaseError(error.localizedDescription)
            return false
        }
        
        return true
    }
    
    // MARK: - Error message methods
    
    func showPodcastAddingConfirmation(numberOfEpisodes: Int, podcastName: String) {
        if numberOfEpisodes == 1 {
            alertTitle = String(format: LocalizableStrings.PodcastPreview.Messages.readyToDownloadSingleEpisodeConfirmationTitle, podcastName)
        } else {
            alertTitle = String(format: LocalizableStrings.PodcastPreview.Messages.readyToDownloadMultipleEpisodesConfirmationTitle, numberOfEpisodes, podcastName)
        }
        alertMessage = LocalizableStrings.PodcastPreview.Messages.readyToDownloadConfirmationMessage
        alertType = .twoOptions
        displayAlert = true
    }
    
    func showLowStorageWarning() {
        alertTitle = "Unable To Continue"
        alertMessage = "You would have less than 2 GB remaining on your iPhone after downloading this podcast. Please delete some old apps and data and try again."
        alertType = .singleOption
        displayAlert = true
    }
    
    private func showPodcastAlreadyExistsAlert(podcastName: String) {
        alertTitle = "This Podcast was Already Archived"
        alertMessage = "It's not possible to add '\(podcastName)' because it already exists in the archive. If you would like to add more episodes, please go to the podcast's archive page."
        alertType = .singleOption
        displayAlert = true
    }

    private func showPodcastIDNotFoundAlert() {
        alertTitle = "No Podcast Matching This ID Was Found"
        alertMessage = "Please try a different ID."
        alertType = .singleOption
        displayAlert = true
    }

    private func showPodcastHadNoEpisodesAlert() {
        alertTitle = "This Podcast Has No Episodes"
        alertMessage = "No episodes were found for this podcast."
        alertType = .singleOption
        displayAlert = true
    }
    
    private func showNoEpisodesSelectedAlert() {
        alertTitle = "No Episode Selected"
        alertMessage = "Select at least one episode to download."
        alertType = .singleOption
        displayAlert = true
    }
    
    private func showLocalDatabaseError(_ errorBody: String) {
        alertTitle = "LocalDatabase error"
        alertMessage = errorBody
        alertType = .singleOption
        displayAlert = true
    }
    
    private func showGenericError(_ errorText: String) {
        alertTitle = errorText
        alertType = .singleOption
        displayAlert = true
    }

}
