import Combine

class MainViewViewModel: ObservableObject {
    
    @Published var podcasts: [Podcast]
    @Published var displayPodcastList: Bool = false
    
    // Alerts
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    
    init(podcasts: [Podcast] = [Podcast]()) {
        self.podcasts = podcasts
        displayPodcastList = self.podcasts.count > 0
        updateList()
    }

    func updateList() {
        do {
            guard let podcastsFromDB = try dataManager.getPodcasts() else {
                return
            }
            if podcastsFromDB.count > 0 {
                podcasts = podcastsFromDB
                displayPodcastList = true
            } else {
                displayPodcastList = false
            }
        } catch {
            return showError(title: "Erro Ao Tentar Carregar Podcasts", message: error.localizedDescription)
        }
    }
    
    private func showError(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }

}
