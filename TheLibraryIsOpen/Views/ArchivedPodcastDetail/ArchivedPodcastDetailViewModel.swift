import Foundation
import Combine

class ArchivedPodcastDetailViewModel: ObservableObject {

    @Published var title: String
    @Published var details: String
    @Published var artworkURL: String
    @Published var displayEpisodeList: Bool = false
    
    @Published var episodes = [Episode]()
    @Published var groups = [EpisodeGroup]()
    
    @Published var areAllSelectEpisodeList: Bool = true
    @Published var areAllSelectEpisodeGroupList: Bool = false
    @Published var selectAllButtonTitle: String = "Deselecionar Todos"
    
    @Published var recentsFirst: Bool = true
    
    @Published var downloadAllButtonTitle = ""
    var isAnyEpisodeSelected: Bool {
        get {
            // return episodes.contains { $0.selectedForDownload == true }
            return true
        }
    }
    
    var podcast: Podcast
    
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
        
        if (podcast.episodes?.count ?? 0) > 0 {
            groups = Utils.getEpisodesGroupedByYear(from: podcast.episodes!)
        }
        
        displayEpisodeList = podcast.episodes?.count ?? 0 > 0
        
        let episodesToDownload = episodes.filter {
            $0.offlineStatus == EpisodeOfflineStatus.downloadNotStarted.rawValue
        }
        if episodesToDownload.count > 0 {
            download(episodes: episodesToDownload)
        }
    }
    
    func download(episodes: [Episode]) {
        dataManager.baixarEpisodios(arrayEpisodios: episodes, idPodcast: podcast.id) { [weak self] success in
            if success {
                for i in 0...(episodes.count - 1) {
                    self?.episodes[i].offlineStatus = EpisodeOfflineStatus.availableOffline.rawValue
                }
                self?.showAlert(withTitle: "Episode Download Successful", message: "Yay!")
            } else {
                self?.showAlert(withTitle: "Episode Download Unsuccessful", message: ":(")
            }
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
        alertMessage = "Would you like to contribute? Make a pull request :)"
        displayAlert = true
    }

}
