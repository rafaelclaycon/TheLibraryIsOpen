import Combine

class PodcastHistoryViewViewModel: ObservableObject {

    @Published var navBarTitle: String
    @Published var records: [PodcastHistoryRecord]?
    @Published var showList: Bool
    
    init(podcastId: Int, podcastTitle: String) {
        navBarTitle = String(format: LocalizableStrings.PodcastHistoryView.navBarTitle, podcastTitle)
        do {
            records = try dataManager.getPodcastHistory(from: podcastId)
            showList = true
        } catch {
            records = nil
            showList = false
            print(error.localizedDescription)
        }
    }

}
