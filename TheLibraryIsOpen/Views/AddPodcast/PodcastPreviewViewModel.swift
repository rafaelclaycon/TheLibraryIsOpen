import Combine
import Foundation

class PodcastPreviewViewModel: ObservableObject {
    
    var podcast: Podcast

    @Published var title: String
    @Published var details: String
    @Published var artworkURL: String
    @Published var displayEpisodeList: Bool = false
    
    // MARK: - Episode list variables
    @Published var episodes = [Episodio]()
    @Published var selectionKeeper = Set<String>()
    @Published var allEpisodesSelected: Bool = true
    @Published var recentsFirst: Bool = true
    
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
        
        artworkURL = podcast.urlCapa
        
        title = podcast.titulo
        details = podcast.episodios?.count ?? 0 > 0 ? Utils.getSubtituloPodcast(episodes: podcast.episodios!) : ""
        episodes = podcast.episodios!
        
        selectAllEpisodes()
        updateDownloadButton(selectedIDs: Array(selectionKeeper))
        
        if (podcast.episodios?.count ?? 0) > 0 {
            groups = Utils.getEpisodesGroupedByYear(from: podcast.episodios!)
        }
        
        displayEpisodeList = podcast.episodios?.count ?? 0 > 0
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
    func toggleSortList() {
        if recentsFirst {
            sortEpisodesByPubDateAscending()
        } else {
            sortEpisodesByPubDateDescending()
        }
    }
    
    func sortEpisodesByPubDateAscending() {
        episodes.sort { $0.dataPublicacao! < $1.dataPublicacao! }
        recentsFirst = false
    }
    
    func sortEpisodesByPubDateDescending() {
        episodes.sort { $0.dataPublicacao! > $1.dataPublicacao! }
        recentsFirst = true
    }
    
    // MARK: - Download button methods
    func updateDownloadButton(selectedIDs: [String]) {
        let selectedEpisodes = episodes.filter {
            selectedIDs.contains($0.id)
        }
        if selectedEpisodes.count == 0 {
            downloadAllButtonTitle = "Baixar 0 episódios"
            isAnyEpisodeSelected = false
        } else if selectedEpisodes.count == 1 {
            downloadAllButtonTitle = "Baixar 1 episódio\(Utils().getSize(ofEpisodes: selectedEpisodes))"
            isAnyEpisodeSelected = true
        } else {
            downloadAllButtonTitle = "Baixar \(selectedEpisodes.count) episódios\(Utils().getSize(ofEpisodes: selectedEpisodes))"
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
        
        podcast.episodios = nil
        
        do {
            try dataManager.persist(podcast: podcast, withEpisodes: episodesToDownload)
        } catch {
            showLocalStorageError(error.localizedDescription)
        }
        
        return true
    }
    
    // MARK: - Error message methods

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
