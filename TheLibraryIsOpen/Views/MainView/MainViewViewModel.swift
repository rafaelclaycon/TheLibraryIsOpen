import Combine
import UIKit

class MainViewViewModel: ObservableObject {
    
    @Published var podcasts: [Podcast]
    @Published var displayPodcastList: Bool = false
    @Published var sortOption: Int
    @Published var viewOption: Int
    @Published var totalSize: String
    
    // Alerts
    @Published var alertTitle: String = .empty
    @Published var alertMessage: String = .empty
    @Published var alertAuxiliaryInfo: Int? = nil
    @Published var showAlert: Bool = false
    @Published var alertType: AlertType = .singleOption
    
    init(podcasts: [Podcast] = [Podcast]()) {
        self.podcasts = podcasts
        sortOption = UserSettings.getArchiveSortOption()
        viewOption = UserSettings.getArchiveRowAdditionalInfoToShowOption()
        totalSize = .empty
        displayPodcastList = podcasts.count > 0
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
                
                if sortOption == 0 {
                    sortPodcastsByTitleAscending()
                } else {
                    sortPodcastsByTotalSizeDescending()
                }
                
                var localTotalSize: Int = 0
                for podcast in podcastsFromDB {
                    localTotalSize += podcast.totalSize == nil ? 0 : podcast.totalSize!
                }
                totalSize = String(format: LocalizableStrings.MainView.totalDeviceSpaceTaken, Utils.getFormattedFileSize(of: localTotalSize))
                
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
    
    func sortPodcastsByTitleAscending() {
        podcasts.sort(by: { $0.title.withoutDiacritics() < $1.title.withoutDiacritics() })
    }
    
    func sortPodcastsByTotalSizeDescending() {
        podcasts.sort(by: { $0.totalSize ?? 0 > $1.totalSize ?? 0 })
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
