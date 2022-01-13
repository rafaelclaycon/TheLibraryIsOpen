import Combine
import Foundation

class InstructionsBViewModel: ObservableObject {

    @Published var entrada = ""
    @Published var processando = false
    @Published var processingViewMessage = ""
    @Published var podcastDetailViewModel = PodcastPreviewViewModel(podcast: Podcast(id: 0))
    @Published var isMostrandoPodcastDetailView = false
    
    // MARK: - Alert variables
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    @Published var displayAlert: Bool = false
    
    func processLink() {
        processingViewMessage = LocalizableStrings.InstructionsBView.loaderLabel
        processando = true
        
        do {
            try dataManager.obterPodcast(applePodcastsURL: entrada) { [weak self] podcast, error in
                guard let strongSelf = self else {
                    return
                }
                guard error == nil else {
                    fatalError(error!.localizedDescription)
                }
                guard let podcast = podcast else {
                    fatalError()
                }
                
                do {
                    guard try dataManager.exists(podcastId: podcast.id) == false else {
                        DispatchQueue.main.async {
                            strongSelf.processando = false
                            strongSelf.showPodcastAlreadyExistsAlert(podcastName: podcast.title)
                        }
                        return
                    }
                } catch {
                    DispatchQueue.main.async {
                        strongSelf.processando = false
                        strongSelf.showOtherError(errorTitle: "Local Database Error", errorBody: "An error occured while trying to check if the podcast already exists in the local database. Please report this to the developer.")
                    }
                }
                
                strongSelf.podcastDetailViewModel = PodcastPreviewViewModel(podcast: podcast)
                strongSelf.processando = false
                strongSelf.isMostrandoPodcastDetailView = true
                
                //let primeiroEp = podcast.episodios![0]
                //let ultimoEp = podcast.episodios![podcast.episodios!.count - 1]
                
                //strongSelf.titulo = podcast.titulo
                //strongSelf.primeiroEp = primeiroEp.titulo
                //print("Ep no topo da lista: \(primeiroEp.remoteUrl)")
                //strongSelf.ultimoEp = ultimoEp.titulo
                //print("Último ep da lista: \(ultimoEp.remoteUrl)")
                //strongSelf.qtd = Utils.getSubtituloPodcast(episodes: podcast.episodios!)
                
                //let episodios = podcast.episodios!
                
                /*var tamanho = 0
                for episodio in episodios {
                    tamanho += episodio.tamanho
                }
                
                print("TAMANHO TOTAL: \(tamanho) bytes")*/
                
                //strongSelf.processando = false
                
                /*dataManager.baixarEpisodios(arrayEpisodios: episodios, idPodcast: podcast.id) { _ in
                    strongSelf.processando = false
                }*/
            }
        } catch {
            processando = false
            // TODO
        }
    }
    
    // MARK: - Error message methods
    
    private func showPodcastAlreadyExistsAlert(podcastName: String) {
        alertTitle = "This Podcast Is Already Archived"
        alertMessage = "'\(podcastName)' already exists in the archive. If you would like to download more episodes, please go to the podcast's archive page and do it there."
        displayAlert = true
    }
    
    private func showOtherError(errorTitle: String, errorBody: String) {
        alertTitle = errorTitle
        alertMessage = errorBody
        displayAlert = true
    }

}
