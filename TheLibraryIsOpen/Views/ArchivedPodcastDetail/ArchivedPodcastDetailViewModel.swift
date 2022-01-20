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
    
    @Published var showingFileExplorer: Bool = false
    @Published var zipFileURL: URL? = nil
    
    // ProcessingView
    @Published var isShowingProcessingView = false
    @Published var processingViewMessage = ""
    
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
        let spaceDescription = Utils.getSizeOf(episodes: episodes, withSpaceAndParenteses: false)
        self.totalFilesize = spaceDescription.isEmpty == false ? spaceDescription : LocalizableStrings.ArchivedPodcastDetail.unknownTotalSize
        self.lastCheckDate = podcast.lastCheckDate?.asShortString() ?? LocalizableStrings.ArchivedPodcastDetail.unknownLastCheckedDate
        
        let episodesToDownload = episodes.filter {
            $0.offlineStatus == EpisodeOfflineStatus.downloadNotStarted.rawValue
        }
        if episodesToDownload.count > 0 {
            download(episodes: episodesToDownload)
        }
        
        episodes.forEach { episode in
            switch EpisodeOfflineStatus(rawValue: episode.offlineStatus) {
            case .availableOffline:
                downloadedKeeper.insert(episode.id)
            case .downloadError:
                downloadErrorKeeper.insert(episode.id)
            default:
                downloadingKeeper.insert(episode.id)
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
                dataManager.updateEpisodesLocalFilepathAndOfflineStatus(strongSelf.episodes)
                
                //self?.showAlert(withTitle: "Episode Download Successful", message: "Yay!")
            } else {
                for i in 0...(episodes.count - 1) {
                    strongSelf.downloadErrorKeeper.insert(strongSelf.episodes[i].id)
                    strongSelf.episodes[i].offlineStatus = EpisodeOfflineStatus.downloadError.rawValue
                }
                self?.showAlert(withTitle: "Episode Download Unsuccessful", message: ":(")
            }
        }
    }
    
//    func showShareSheet() {
//        guard let urlShare = URL(string: appleURL) else {
//            return
//        }
//        let activityVC = UIActivityViewController(activityItems: [urlShare], applicationActivities: nil)
//        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
//    }
    
    fileprivate func directoryExistsAtPath(_ path: String) -> Bool {
        var isDirectory = ObjCBool(true)
        let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }
    
    func zipAll() {
        processingViewMessage = "Criando .zip..."
        isShowingProcessingView = true
        
        let documentsDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let sourceURL = documentsDirURL.appendingPathComponent("Podcasts/\(podcast.id)")
        
        var name = ""
        if episodes.count == 1 {
            name = String(format: LocalizableStrings.ArchivedPodcastDetail.Export.exportedFileNameSingleEpisode, podcast.title, Date().asDashSeparatedYMDString())
        } else {
            name = String(format: LocalizableStrings.ArchivedPodcastDetail.Export.exportedFileNameMultipleEpisodes, podcast.title, episodes.count, Date().asDashSeparatedYMDString())
        }
        
        var destinationURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        destinationURL.appendPathComponent("ExportedArchives/" + name + ".zip")
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let docURL = URL(string: documentsDirectory)!
        let dataPath = docURL.appendingPathComponent("ExportedArchives")
        if !FileManager.default.fileExists(atPath: dataPath.absoluteString) {
            do {
                try FileManager.default.createDirectory(atPath: dataPath.absoluteString, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription);
            }
        }
        
        do {
            let fileManager = FileManager()
            
            try fileManager.zipItem(at: sourceURL, to: destinationURL)
            isShowingProcessingView = false
            
            self.zipFileURL = destinationURL
            self.showingFileExplorer = true
            //showAlert(withTitle: "Episode Export Successful", message: destinationURL.lastPathComponent)
        } catch {
            isShowingProcessingView = false
            showAlert(withTitle: "Creation of ZIP archive failed with error", message: error.localizedDescription)
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
