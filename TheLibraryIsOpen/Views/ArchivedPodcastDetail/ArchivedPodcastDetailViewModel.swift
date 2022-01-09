import Foundation
import Combine

class ArchivedPodcastDetailViewModel: ObservableObject {

    @Published var title: String
    @Published var details: String
    @Published var artworkURL: String
    @Published var displayEpisodeList: Bool = false
    
    @Published var episodes = [Episodio]()
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
        
        artworkURL = podcast.urlCapa
        
        title = podcast.titulo
        details = podcast.episodios?.count ?? 0 > 0 ? Utils.getSubtituloPodcast(episodes: podcast.episodios!) : ""
        episodes = podcast.episodios!
        
        applyToAllEpisodes(select: true)
        
        if (podcast.episodios?.count ?? 0) > 0 {
            groups = Utils.getEpisodesGroupedByYear(from: podcast.episodios!)
        }
        
        displayEpisodeList = podcast.episodios?.count ?? 0 > 0
    }
    
    func applyToAllEpisodes(select: Bool) {
        if episodes.count > 0 {
            for i in 0...(episodes.count - 1) {
                //episodes[i].selectedForDownload = select
            }
        }
        areAllSelectEpisodeList = select
    }
    
    func download(episodeIDs: Set<String>) -> Bool {
        let episodesToDownload = episodes.filter {
            episodeIDs.contains($0.id)
        }
        
        guard episodesToDownload.count > 0 else {
            showNoEpisodesSelectedAlert()
            return false
        }
        
        podcast.episodios = nil
        
        do {
            try dataManager.persist(podcast: podcast, withEpisodes: episodesToDownload)
        } catch {
            showLocalStorageError(error.localizedDescription)
        }
        
        return true
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
    
    private func showGenericError(_ errorText: String) {
        alertTitle = errorText
        displayAlert = true
    }

}
