import Combine

class MainViewViewModel: ObservableObject {
    
    @Published var podcasts: [Podcast]
    @Published var displayPodcastList: Bool = false
    @Published var numberOfPodcasts: String = ""
    
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
                sortPodcastsByTitleAscending()
                numberOfPodcasts = getNumberOfPodcastsText()
                displayPodcastList = true
            } else {
                displayPodcastList = false
            }
        } catch {
            return showError(title: "Erro Ao Tentar Carregar Podcasts", message: error.localizedDescription)
        }
    }
    
    private func getNumberOfPodcastsText() -> String {
        if podcasts.count == 0 {
            return "No podcasts"
        } else if podcasts.count == 1 {
            return "1 podcast"
        }
        return "\(podcasts.count) podcasts"
    }
    
    private func showError(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
    
    private func sortPodcastsByTitleAscending() {
        podcasts.sort(by: { $0.title < $1.title })
    }
    
    func dummyCall() {
        print("Not implemented yet.")
    }

}
