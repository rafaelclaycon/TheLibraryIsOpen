import Combine
import Foundation

class PasteLinkViewViewModel: ObservableObject {

    @Published var linkInput = String.empty
    @Published var isShowingProcessingView = false
    @Published var processingViewMessage = String.empty
    @Published var podcastDetailViewModel = PodcastPreviewViewModel(podcast: Podcast(id: 0))
    @Published var isShowingPodcastPreview = false
    
    // MARK: - Alert variables
    @Published var alertTitle: String = .empty
    @Published var alertMessage: String = .empty
    @Published var displayAlert: Bool = false
    
    func processLink() {
        DispatchQueue.main.async {
            self.processingViewMessage = LocalizableStrings.PasteLinkView.loaderLabel
            self.isShowingProcessingView = true
        }
        
        do {
            try dataManager.getPodcast(from: linkInput) { [weak self] podcast, error in
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
                            strongSelf.isShowingProcessingView = false
                            strongSelf.showPodcastAlreadyExistsAlert(podcastName: podcast.title)
                        }
                        return
                    }
                } catch {
                    DispatchQueue.main.async {
                        strongSelf.isShowingProcessingView = false
                        strongSelf.showOtherError(errorTitle: "Local Database Error", errorBody: "An error occured while trying to check if the podcast already exists in the local database. Please report this to the developer.")
                    }
                }
                
                DispatchQueue.main.async {
                    strongSelf.podcastDetailViewModel = PodcastPreviewViewModel(podcast: podcast)
                    strongSelf.isShowingProcessingView = false
                    strongSelf.isShowingPodcastPreview = true
                }
            }
        } catch LinkWizardError.spotifyLink {
            DispatchQueue.main.async {
                self.linkInput = String.empty
                self.isShowingProcessingView = false
                self.showSpotifyLinksNotSupportedAlert()
            }
        } catch LinkWizardError.pocketCastsLink_innerApplePodcastsLinkIsInvalid {
            DispatchQueue.main.async {
                self.isShowingProcessingView = false
                self.showInvalidApplePodcastsLinkAlert()
            }
        } catch {
            DispatchQueue.main.async {
                self.isShowingProcessingView = false
                self.showOtherError(errorTitle: "Failed to Get Podcast", errorBody: error.localizedDescription)
            }
        }
    }
    
    // MARK: - Error message methods
    
    private func showPodcastAlreadyExistsAlert(podcastName: String) {
        alertTitle = "This Podcast Is Already Archived"
        alertMessage = "'\(podcastName)' already exists in the archive. If you would like to download more episodes, please go to the podcast's archive page and do it there."
        displayAlert = true
    }
    
    private func showSpotifyLinksNotSupportedAlert() {
        alertTitle = LocalizableStrings.PasteLinkView.spotifyLinksNotSupportedWarningTitle
        alertMessage = LocalizableStrings.PasteLinkView.spotifyLinksNotSupportedWarningMessage
        displayAlert = true
    }
    
    private func showInvalidApplePodcastsLinkAlert() {
        alertTitle = "Unable To Extract a Valid Apple Podcasts Link"
        alertMessage = "Try obtaining this podcast's link directly from the Podcasts app."
        displayAlert = true
    }
    
    private func showOtherError(errorTitle: String, errorBody: String) {
        alertTitle = errorTitle
        alertMessage = errorBody
        displayAlert = true
    }

}
