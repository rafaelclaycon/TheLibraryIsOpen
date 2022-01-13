import Combine
import Foundation

class InstructionsBViewModel: ObservableObject {

    @Published var linkInput = ""
    @Published var isShowingProcessingView = false
    @Published var processingViewMessage = ""
    @Published var podcastDetailViewModel = PodcastPreviewViewModel(podcast: Podcast(id: 0))
    @Published var isShowingPodcastPreview = false
    
    // MARK: - Alert variables
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    @Published var displayAlert: Bool = false
    
    func processLink() {
        processingViewMessage = LocalizableStrings.InstructionsBView.loaderLabel
        isShowingProcessingView = true
        
        do {
            try dataManager.obterPodcast(applePodcastsURL: linkInput) { [weak self] podcast, error in
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
        } catch LinkAssistantError.spotifyLink {
            DispatchQueue.main.async {
                self.linkInput = ""
                self.isShowingProcessingView = false
                self.showSpotifyLinksNotSupportedAlert()
            }
        } catch {
            DispatchQueue.main.async {
                self.isShowingProcessingView = false
                // TO DO
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
        alertTitle = "Spotify Links Are Not Supported"
        alertMessage = "Please try obtaining a link from one of the supported services."
        displayAlert = true
    }
    
    private func showOtherError(errorTitle: String, errorBody: String) {
        alertTitle = errorTitle
        alertMessage = errorBody
        displayAlert = true
    }

}
