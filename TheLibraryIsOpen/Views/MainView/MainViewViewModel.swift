import Combine

class MainViewViewModel: ObservableObject {
    
    @Published var podcasts: [Podcast]
    @Published var displayPodcastList: Bool = false
    
    // Alerts
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    @Published var alertAuxiliaryInfo: Int? = nil
    @Published var showAlert: Bool = false
    @Published var alertType: AlertType = .singleOption
    
    init(podcasts: [Podcast] = [Podcast]()) {
        self.podcasts = podcasts
        displayPodcastList = self.podcasts.count > 0
        updateList()
    }

    func updateList() {
        do {
            guard let podcastsFromDB = try dataManager.getPodcasts() else {
                displayPodcastList = false
                return
            }
            if podcastsFromDB.count > 0 {
                podcasts = podcastsFromDB
                sortPodcastsByTitleAscending()
                displayPodcastList = true
            } else {
                displayPodcastList = false
            }
        } catch {
            return showError(title: LocalizableStrings.MainView.ErrorMessages.errorLoadingPodcasts, message: error.localizedDescription)
        }
    }
    
    private func showError(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
    
    private func sortPodcastsByTitleAscending() {
        podcasts.sort(by: { $0.title < $1.title })
    }
    
    func removePodcast(withId podcastId: Int) {
        do {
            try dataManager.deletePodcastFromArchive(withId: podcastId)
        } catch {
            showPodcastDeletionError(withMessage: error.localizedDescription)
        }
        if let indexOfPodcastToBeDeleted = podcasts.firstIndex(where: {$0.id == podcastId}) {
            podcasts.remove(at: indexOfPodcastToBeDeleted)
        }
        updateList()
    }
    
    func showPodcastDeletionConfirmation() {
        alertTitle = LocalizableStrings.MainView.ErrorMessages.podcastDeletionConfirmationTitle
        alertMessage = LocalizableStrings.MainView.ErrorMessages.podcastDeletionConfirmationMessage
        alertType = .speciallyPreparedOption
        showAlert = true
    }
    
    func showPodcastDeletionError(withMessage message: String) {
        alertTitle = LocalizableStrings.MainView.ErrorMessages.deletionFailureTitle
        alertMessage = message
        alertType = .singleOption
        showAlert = true
    }

}
