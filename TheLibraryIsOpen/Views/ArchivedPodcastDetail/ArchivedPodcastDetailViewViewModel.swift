import Combine
import UIKit

class ArchivedPodcastDetailViewViewModel: ObservableObject {

    var podcast: Podcast
    
    @Published var title: String
    @Published var details: String
    @Published var artworkURL: String
    @Published var episodeCount: String = .empty
    @Published var totalFilesize: String = .empty
    @Published var lastCheckDate: String = .empty
    @Published var displayEpisodeList: Bool = false
    @Published var episodes = [Episode]()
    @Published var areAllSelectEpisodeList: Bool = true
    @Published var episodeListSorting: SortOption = .fromNewToOld
    @Published var viewOption: Int = 0
    @Published var displayEpisodeArtwork: Bool
    @Published var detailViewToShow: ArchivedPodcastSubdetailViewToShow
    @Published var episodeDetailToShow: Episode?
    
    @Published var progressViewMessage: String = .empty
    @Published var downloadOperationStatus: DownloadOperationStatus = .stopped
    @Published var currentDownloadPercentage = 0.0
    @Published var totalDownloadPercentage = 100.0
    @Published var showOverallDownloadProgress: Bool
    
    // List status keepers
    @Published var downloadingKeeper: [String: Double] = [:]
    @Published var downloadedKeeper = Set<String>()
    @Published var downloadErrorKeeper = Set<String>()
    
    @Published var downloadAllButtonTitle = String.empty
    
    @Published var showingFileExplorer: Bool = false
    @Published var zipFileURL: URL? = nil
    
    // ProcessingView
    @Published var isShowingProcessingView = false
    @Published var processingViewMessage = String.empty
    
    // Alerts
    @Published var alertTitle: String = .empty
    @Published var alertMessage: String = .empty
    @Published var displayAlert: Bool = false
    @Published var alertType: AlertType = .singleOption
    @Published var showingModalView = false

    init(podcast: Podcast) {
        self.podcast = podcast
        
        artworkURL = podcast.artworkUrl
        
        title = podcast.title
        details = podcast.episodes?.count ?? 0 > 0 ? Utils.getPodcastSubtitle(episodes: podcast.episodes!) : .empty
        episodes = podcast.episodes!
        
        displayEpisodeArtwork = UserSettings.getDisplayArtworkInArchiveOption()
        detailViewToShow = .episodeDetailView
        episodeDetailToShow = nil
        
        displayEpisodeList = podcast.episodes?.count ?? 0 > 0
        showOverallDownloadProgress = false
        
        // Info
        let downloadedEpisodes = episodes.filter {
            $0.offlineStatus == EpisodeOfflineStatus.availableOffline.rawValue
        }
        self.episodeCount = String(downloadedEpisodes.count)
        let spaceDescription = Utils.getSizeOf(episodes: downloadedEpisodes, withSpaceAndParenteses: false)
        self.totalFilesize = spaceDescription.isEmpty == false ? spaceDescription : LocalizableStrings.ArchivedPodcastDetail.Info.unknownTotalSize
        self.lastCheckDate = podcast.lastCheckDate?.asShortString() ?? LocalizableStrings.ArchivedPodcastDetail.Info.unknownLastCheckedDate
        
        let episodesToDownload = episodes.filter {
            $0.offlineStatus == EpisodeOfflineStatus.downloadNotStarted.rawValue
        }
        if episodesToDownload.count > 0 {
            download(episodes: episodesToDownload)
            showOverallDownloadProgress = true
        }
        
        updateKeepers()
    }
    
    private func updateKeepers() {
        downloadingKeeper.removeAll()
        downloadedKeeper.removeAll()
        downloadErrorKeeper.removeAll()
        
        episodes.forEach { episode in
            switch EpisodeOfflineStatus(rawValue: episode.offlineStatus) {
            case .availableOffline:
                downloadedKeeper.insert(episode.id)
            case .downloadError:
                downloadErrorKeeper.insert(episode.id)
            case .downloadNotStarted:
                downloadingKeeper[episode.id] = 0.0
            default:
                return
            }
        }
    }
    
    /*func toggleEpisodesNotMakedForDownload() {
        if viewOption == 0 {
            episodesToShow = internalEpisodes.filter{
                $0.offlineStatus != EpisodeOfflineStatus.notMarkedForDownload.rawValue
            }
        } else {
            episodesToShow = internalEpisodes
        }
    }*/
    
    func download(episodes: [Episode]) {
        guard episodes.count > 0 else {
            return
        }
        
        totalDownloadPercentage = Double(episodes.count)
        
        downloadOperationStatus = .activelyDownloading
        if episodes.count == 1 {
            progressViewMessage = LocalizableStrings.ArchivedPodcastDetail.DownloadStrip.summaryMessageSingleEpisode
        } else {
            progressViewMessage = String(format: LocalizableStrings.ArchivedPodcastDetail.DownloadStrip.summaryMessageMultipleEpisodes, episodes.count)
        }
        
        dataManager.download(episodeArray: episodes, podcastId: podcast.id, progressCallback: { [weak self] episodeId, fractionCompleted in
            guard let strongSelf = self else {
                return
            }
            strongSelf.downloadingKeeper[episodeId] = fractionCompleted * 100
            
            if fractionCompleted == 1 {
                strongSelf.currentDownloadPercentage += 1
                strongSelf.downloadingKeeper[episodeId] = nil
                strongSelf.downloadedKeeper.insert(episodeId)
            }
        }, completionHandler: { [weak self] success in
            guard let strongSelf = self else {
                return
            }
            
            if success {
                for i in 0...(episodes.count - 1) {
                    if let url = URL(string: strongSelf.episodes[i].remoteUrl) {
                        strongSelf.episodes[i].localFilepath = "Podcasts/\(strongSelf.podcast.id)/\(url.lastPathComponent)"
                        
                        strongSelf.episodes[i].offlineStatus = EpisodeOfflineStatus.availableOffline.rawValue
                        
                        if let newSize = FileSystemOperations.getActualSizeOfFile(atPath: "\(strongSelf.podcast.id)/\(url.lastPathComponent)") {
                            strongSelf.episodes[i].filesize = newSize
                        }
                    }
                }
                
                // Some episodes do not report filesize before being downloaded, so this is important.
                dataManager.updateLocalFileAttributesOnDatabase(for: strongSelf.episodes)
                
                // Log download so that it happears on History
                let downloadedEpisodeCount = ArchivedPodcastDetailViewViewModel.getDownloadedEpisodeCount(from: strongSelf.episodes)
                do {
                    try dataManager.addHistoryRecord(for: strongSelf.podcast.id, with: HistoryRecordType.episodesDownloaded, value1: "\(downloadedEpisodeCount)")
                } catch {
                    print("Unable to log download of \(downloadedEpisodeCount) episode(s) for podcast '\(strongSelf.podcast.title)'.")
                }
            } else {
                for i in 0...(episodes.count - 1) {
                    strongSelf.downloadErrorKeeper.insert(strongSelf.episodes[i].id)
                    strongSelf.episodes[i].offlineStatus = EpisodeOfflineStatus.downloadError.rawValue
                }
                self?.showAlert(withTitle: "Episode Download Unsuccessful", message: ":(")
            }
            
            strongSelf.updateKeepers()
        })
    }
    
    func getExportedEpisodeCount() -> Int {
        let exportedEpisodeCount = episodes.filter {
            $0.localFilepath?.isEmpty == false
        }
        return exportedEpisodeCount.count
    }
    
    static func getDownloadedEpisodeCount(from theseEpisodes: [Episode]) -> Int {
        let downloadedEpisodeCount = theseEpisodes.filter {
            $0.offlineStatus == EpisodeOfflineStatus.availableOffline.rawValue
        }
        return downloadedEpisodeCount.count
    }
    
    func showShareSheet() {
        // Zip
        zipAllEpisodes()
        
        guard let urlShare = self.zipFileURL else {
            return
        }
        
        // Clean
        do {
            try FileSystemOperations.flushTmpDirectory()
        } catch {
            print(error.localizedDescription)
        }
        
        // Show
        let activityVC = UIActivityViewController(activityItems: [urlShare], applicationActivities: nil)
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.rootViewController?.present(activityVC, animated: true, completion: nil)
        }
        
        // Log
        do {
            try dataManager.addHistoryRecord(for: podcast.id, with: HistoryRecordType.archiveExported, value1: "\(getExportedEpisodeCount())", value2: "\(ExportedToOption.thirdPartyService.rawValue)")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func zipAllEpisodes() {
        // Display Please Wait UI
        DispatchQueue.main.async {
            self.processingViewMessage = "Criando .zip..."
            self.isShowingProcessingView = true
        }
        
        var paths = [String]()
        episodes.forEach { episode in
            if let path = episode.localFilepath {
                paths.append(path)
            }
        }
        
        do {
            self.zipFileURL = try Zipper.zip(episodes: paths, of: podcast.id, podcast.title)
            DispatchQueue.main.async {
                self.isShowingProcessingView = false
            }
        } catch {
            DispatchQueue.main.async {
                self.isShowingProcessingView = false
            }
            self.showAlert(withTitle: "Error", message: error.localizedDescription)
        }
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
    
    func dummyCall() {
        print("Not implemented yet.")
    }
    
    // MARK: - Error messages

    private func showPodcastIDNotFoundAlert() {
        alertTitle = "Um Podcast Com Esse ID Não Foi Encontrado"
        alertMessage = "The Library is Open não encontrou um podcast com o ID especificado."
        displayAlert = true
    }

    private func showPodcastHadNoEpisodesAlert() {
        alertTitle = "Podcast Sem Episódios"
        alertMessage = "Não foram encontrados episódios para esse podcast."
        displayAlert = true
    }
    
    private func showNoEpisodesSelectedAlert() {
        alertTitle = "Nenhum Episódio Selecionado"
        alertMessage = "Selecione um ou mais episódios do podcast para baixar."
        displayAlert = true
    }
    
    private func showLocalDatabaseError(_ errorBody: String) {
        alertTitle = "Erro do LocalDatabase"
        alertMessage = errorBody
        displayAlert = true
    }
    
    func showAlert(withTitle alertTitle: String, message alertMessage: String, alertType: AlertType = .singleOption) {
        self.alertTitle = alertTitle
        self.alertMessage = alertMessage
        displayAlert = true
    }

}
