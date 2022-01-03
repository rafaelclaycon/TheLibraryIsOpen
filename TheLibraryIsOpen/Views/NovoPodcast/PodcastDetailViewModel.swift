import Combine
import Foundation

class PodcastDetailViewModel: ObservableObject {

    @Published var displayPodcastArtwork: Bool = false
    @Published var title: String
    @Published var details: String
    @Published var artworkURL: String
    @Published var displayEpisodeList: Bool = false
    
    @Published var episodes = [Episodio]()
    @Published var groups = [EpisodeGroup]()
    
    @Published var areAllSelectEpisodeList: Bool = true
    @Published var areAllSelectEpisodeGroupList: Bool = false
    @Published var selectAllButtonTitle: String = "Deselecionar Todos"
    
    @Published var downloadAllButtonTitle = ""
    var isAnyEpisodeSelected: Bool {
        get {
            return episodes.contains { $0.selectedForDownload == true }
        }
    }
    
    // Alerts
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    @Published var displayAlert: Bool = false

    init(podcast: Podcast) {
        displayPodcastArtwork = false
        artworkURL = podcast.urlCapa
        displayPodcastArtwork = true
        
        title = podcast.titulo
        details = podcast.episodios?.count ?? 0 > 0 ? Utils.getSubtituloPodcast(episodes: podcast.episodios!) : ""
        episodes = podcast.episodios!
        
        applyToAllEpisodes(select: true)
        
        if (podcast.episodios?.count ?? 0) > 0 {
            groups = Utils.getEpisodesGroupedByYear(from: podcast.episodios!)
        }
        
        displayEpisodeList = podcast.episodios?.count ?? 0 > 0
        
        downloadAllButtonTitle = "Baixar \(podcast.episodios?.count ?? 0) episódios\(podcast.getTamanhoEpisodios())"
//        dataManager.getEpisodes(forPodcastID: podcast.id, feedURL: podcast.urlFeed) { episodes, error in
//            guard error == nil else {
//                fatalError(error.debugDescription)
//            }
//            guard let episodes = episodes else {
//                return print("Episodes is empty.")
//            }
//            self.episodes = episodes
//
//            DispatchQueue.main.async {
//                self.displayEpisodeList = episodes.count > 0
//            }
//        }
    }
    
    func applyToAllEpisodes(select: Bool) {
        if episodes.count > 0 {
            for i in 0...(episodes.count - 1) {
                episodes[i].selectedForDownload = select
            }
        }
        areAllSelectEpisodeList = select
    }
    
    func downloadAll() {
        /*do {
            try dataManager.downloadAllEpisodes(from: 916378162)
        } catch DataManagerError.podcastIDNotFound {
            displayPodcastIDNotFoundAlert()
        } catch DataManagerError.podcastHasNoEpisodes {
            displayPodcastHadNoEpisodesAlert()
        } catch {
            fatalError(error.localizedDescription)
        }*/
    }
    
    // MARK: - Error messages

    private func displayPodcastIDNotFoundAlert() {
        alertTitle = "Um Podcast Com Esse ID Não Foi Encontrado"
        alertMessage = "The Library is Open não encontrou um podcast com o ID especificado."
        displayAlert = true
    }

    private func displayPodcastHadNoEpisodesAlert() {
        alertTitle = "Podcast Sem Episódios"
        alertMessage = "Não foram encontrados episódios para esse podcast."
        displayAlert = true
    }

}
