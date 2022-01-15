import Foundation
import Combine
import UIKit
import ZIPFoundation

class ArchivedPodcastDetailViewModel: ObservableObject {

    var podcast: Podcast
    let appleURL = "https://developer.apple.com/design/human-interface-guidelines/ios/controls/buttons/"
    
    @Published var title: String
    @Published var details: String
    @Published var artworkURL: String
    @Published var episodeCount: String = ""
    @Published var totalFilesize: String = ""
    @Published var lastCheckDate: String = ""
    @Published var displayEpisodeList: Bool = false
    @Published var episodes = [Episode]()
    @Published var areAllSelectEpisodeList: Bool = true
    @Published var recentsFirst: Bool = true
    
    // List status keepers
    @Published var downloadingKeeper = Set<String>()
    @Published var downloadedKeeper = Set<String>()
    @Published var downloadErrorKeeper = Set<String>()
    
    @Published var downloadAllButtonTitle = ""
    var isAnyEpisodeSelected: Bool {
        get {
            // return episodes.contains { $0.selectedForDownload == true }
            return true
        }
    }
    
    // Alerts
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    @Published var displayAlert: Bool = false

    init(podcast: Podcast) {
        self.podcast = podcast
        
        artworkURL = podcast.artworkUrl
        
        title = podcast.title
        details = podcast.episodes?.count ?? 0 > 0 ? Utils.getSubtituloPodcast(episodes: podcast.episodes!) : ""
        episodes = podcast.episodes!
        
        displayEpisodeList = podcast.episodes?.count ?? 0 > 0
        
        self.episodeCount = String(episodes.count)
        self.totalFilesize = Utils.getSizeOf(episodes: episodes, withSpaceAndParenteses: false)
        self.lastCheckDate = podcast.lastCheckDate?.asShortString() ?? "Unknown"
        
        if CommandLine.arguments.contains("-DO_NOT_DOWNLOAD_EPISODES_UPON_OPENING_ARCHIVED_PODCAST") == false {
            let episodesToDownload = episodes.filter {
                $0.offlineStatus == EpisodeOfflineStatus.downloadNotStarted.rawValue
            }
            if episodesToDownload.count > 0 {
                download(episodes: episodesToDownload)
            }
        }
    }
    
    func download(episodes: [Episode]) {
        dataManager.download(episodeArray: episodes, podcastId: podcast.id) { [weak self] success in
            guard let strongSelf = self else {
                return
            }
            
            if success {
                for i in 0...(episodes.count - 1) {
                    strongSelf.downloadedKeeper.insert(strongSelf.episodes[i].id)
                    
                    if let url = URL(string: strongSelf.episodes[i].remoteUrl) {
                        strongSelf.episodes[i].localFilepath = "Podcasts/\(strongSelf.podcast.id)/\(url.lastPathComponent)"
                    }
                    
                    strongSelf.episodes[i].offlineStatus = EpisodeOfflineStatus.availableOffline.rawValue
                }
                
                // Persist
                //dataManager.per
                
                self?.showAlert(withTitle: "Episode Download Successful", message: "Yay!")
            } else {
                for i in 0...(episodes.count - 1) {
                    strongSelf.downloadErrorKeeper.insert(strongSelf.episodes[i].id)
                    strongSelf.episodes[i].offlineStatus = EpisodeOfflineStatus.downloadError.rawValue
                }
                self?.showAlert(withTitle: "Episode Download Unsuccessful", message: ":(")
            }
        }
    }
    
    func showShareSheet() {
        guard let urlShare = URL(string: appleURL) else {
            return
        }
        let activityVC = UIActivityViewController(activityItems: [urlShare], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
    
    func zip() {
        for episode in episodes {
            print(episode.localFilepath)
        }
        
        let fileManager = FileManager()
        let currentWorkingPath = fileManager.currentDirectoryPath
        var sourceURL = URL(fileURLWithPath: currentWorkingPath)
        sourceURL.appendPathComponent("file.txt")
        
        var destinationURL = URL(fileURLWithPath: currentWorkingPath)
        destinationURL.appendPathComponent("archive.zip")
        
        do {
            try fileManager.zipItem(at: sourceURL, to: destinationURL)
        } catch {
            print("Creation of ZIP archive failed with error:\(error)")
        }
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
    
    private func showLocalStorageError(_ errorBody: String) {
        alertTitle = "Erro do LocalStorage"
        alertMessage = errorBody
        displayAlert = true
    }
    
    private func showAlert(withTitle alertTitle: String, message alertMessage: String) {
        self.alertTitle = alertTitle
        self.alertMessage = alertMessage
        displayAlert = true
    }
    
    func showExportDestinationNotSupportedYet(providerName: String) {
        alertTitle = "\(providerName) Not Supported Yet"
        alertMessage = "Would you like to contribute? Please consider making a pull request :)"
        displayAlert = true
    }
    
    func placeOrder() { }
    func adjustOrder() { }

}
