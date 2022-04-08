import Combine
import UIKit

class PasteLinkViewViewModel: ObservableObject {

    @Published var linkInput = String.empty
    @Published var isShowingProcessingView = false
    @Published var processingViewMessage = String.empty
    @Published var podcastDetailViewModel = PodcastPreviewViewModel(podcast: Podcast(id: 0))
    @Published var isShowingPodcastPreview = false
    @Published var showNewScreen: Bool
    @Published var pasteboardContents: String = ""
    
    // MARK: - Alert variables
    @Published var alertTitle: String = .empty
    @Published var alertMessage: String = .empty
    @Published var displayAlert: Bool = false
    
    init() {
        showNewScreen = UserSettings.getShowNewPasteLinkScreenOption()
    }
    
    func process(link: String) {
        DispatchQueue.main.async {
            self.processingViewMessage = LocalizableStrings.PasteLinkView.loaderLabel
            self.isShowingProcessingView = true
        }
        
        do {
            try dataManager.getPodcast(from: link) { [weak self] podcast, error in
                guard let strongSelf = self else {
                    return
                }
                guard error == nil else {
                    DispatchQueue.main.async {
                        strongSelf.isShowingProcessingView = false
                        strongSelf.showOtherError(errorTitle: LocalizableStrings.PasteLinkView.unableToAccessFeedErrorTitle,
                                                  errorBody: LocalizableStrings.PasteLinkView.unableToAccessFeedErrorMessage)
                    }
                    return
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
        } catch DataManagerError.iTunesQueryReturnedNoResults {
            DispatchQueue.main.async {
                self.isShowingProcessingView = false
                self.showOtherError(errorTitle: "Unable iTunesQueryReturnedNoResults", errorBody: "iTunesQueryReturnedNoResults")
            }
        } catch {
            DispatchQueue.main.async {
                self.isShowingProcessingView = false
                self.showOtherError(errorTitle: "Failed to Get Podcast", errorBody: error.localizedDescription)
            }
        }
    }
    
    func inspectPasteboard() {
        // We are only interested in strings
        if !UIPasteboard.general.hasStrings { return }
        
        UIPasteboard.general.detectPatterns(for: [UIPasteboard.DetectionPattern.probableWebURL], completionHandler: { [weak self] result in
            switch result {
            case .success(let detectedPatterns):
                // A pattern detection is completed,
                // regardless of whether the pasteboard has patterns we care about.
                // So we have to check if the detected patterns contains our patterns.
                
                if detectedPatterns.contains(UIPasteboard.DetectionPattern.probableWebURL) {
                    // Will match if the pasteboard string has a URL within it
                    let detectedURL = UIPasteboard.general.string!
                    DispatchQueue.main.async {
                        self?.pasteboardContents = detectedURL
                    }
                    self?.process(link: detectedURL)
                } else {
                    // We won't be retrieving the value, so we won't get a notification banner
                    DispatchQueue.main.async {
                        self?.pasteboardContents = "Not something we want to deal with"
                    }
                }
            case .failure(let error):
                // This never gets called
                DispatchQueue.main.async {
                    self?.pasteboardContents = error.localizedDescription
                }
            }
        })
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
        alertTitle = LocalizableStrings.PasteLinkView.invalidApplePodcastsLinkErrorTitle
        alertMessage = LocalizableStrings.PasteLinkView.invalidApplePodcastsLinkErrorMessage
        displayAlert = true
    }
    
    private func showOtherError(errorTitle: String, errorBody: String) {
        alertTitle = errorTitle
        alertMessage = errorBody
        displayAlert = true
    }

}
